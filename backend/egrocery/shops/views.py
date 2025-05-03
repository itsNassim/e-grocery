from rest_framework import generics
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework.permissions import AllowAny
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.shortcuts import get_object_or_404




from django.contrib.auth.models import User
from .serializers import *

#Sing Up
class RegisterView(generics.CreateAPIView):
    serializer_class = RegisterSerializer
    permission_classes = [AllowAny]

#GEt User Info Using Token
class GetUserInfoView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        return Response({
            "id": user.id,
            "full_name": user.full_name,
            "email": user.email,
            "phone_number": user.phone_number,
        })



#Update User Info
@api_view(['PUT'])
def update_user_info(request):
    user = request.user  # Get the current authenticated user
    if request.method == 'PUT':
        serializer = UserUpdateSerializer(user, data=request.data, partial=True)  # partial=True allows updating only the provided fields
        if serializer.is_valid():
            serializer.save()  # Save the updated data to the user instance
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


#Chnage Password
class ChangePasswordView(APIView):
    permission_classes = [IsAuthenticated]

    def put(self, request):
        user = request.user
        data = request.data

        current_password = data.get("current_password")
        new_password = data.get("new_password")

        if not current_password or not new_password:
            return Response(
                {"detail": "Current and new password are required."},
                status=status.HTTP_400_BAD_REQUEST
            )

        if not user.check_password(current_password):
            return Response(
                {"detail": "Current password is incorrect."},
                status=status.HTTP_400_BAD_REQUEST
            )

        user.set_password(new_password)
        user.save()

        return Response({"detail": "Password updated successfully."}, status=status.HTTP_200_OK)


#Delete Account
class DeleteAccountView(APIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request):
        user = request.user
        user.delete()
        return Response({"detail": "Account deleted successfully."}, status=status.HTTP_200_OK)


#Get Categories
@api_view(['GET'])
def get_all_categories(request):
    categories = Category.objects.all()
    serializer = CategorySerializer(categories, many=True, context={'request': request})
    return Response(serializer.data)


#get stores
@api_view(['GET'])
def get_all_stores(request):
    stores = Store.objects.all()
    serializer = StoreSerializer(stores, many=True, context={'request': request})
    return Response(serializer.data)

#get product
@api_view(['GET'])
def get_all_products(request):
    products = Product.objects.all()
    serializer = ProductSerializer(products, many=True, context={'request': request})
    return Response(serializer.data)

#-------<Shopping Cart>-------------
class ShoppingCartView(APIView):
    permission_classes = [IsAuthenticated]

    def get_cart(self, user):
        cart, _ = ShoppingCart.objects.get_or_create(user=user)
        return cart

    def get(self, request):
        cart = self.get_cart(request.user)
        serializer = ShoppingCartSerializer(cart, context={'request': request})
        return Response(serializer.data)

class AddToCartView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = AddCartItemSerializer(data=request.data)
        if serializer.is_valid():
            product = get_object_or_404(Product, id=serializer.validated_data['product_id'])
            quantity = serializer.validated_data['quantity']
            cart = ShoppingCart.objects.get_or_create(user=request.user)[0]

            # Check if item already exists
            item = cart.items.filter(product=product, user=request.user).first()
            if item:
                item.quantity += quantity
                item.save()
            else:
                item = CartItem.objects.create(user=request.user, product=product, quantity=quantity)
                cart.items.add(item)

            return Response(CartItemSerializer(item, context={'request': request}).data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class RemoveFromCartView(APIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request, product_id):
        cart = ShoppingCart.objects.get_or_create(user=request.user)[0]
        item = cart.items.filter(product__id=product_id, user=request.user).first()
        if item:
            cart.items.remove(item)
            item.delete()
            return Response({"detail": "Item removed."}, status=status.HTTP_200_OK)
        return Response({"detail": "Item not found."}, status=status.HTTP_404_NOT_FOUND)

class UpdateCartItemQuantityView(APIView):
    permission_classes = [IsAuthenticated]

    def patch(self, request):
        serializer = UpdateCartItemSerializer(data=request.data)
        if serializer.is_valid():
            product_id = serializer.validated_data['product_id']
            quantity = serializer.validated_data['quantity']
            cart = ShoppingCart.objects.get_or_create(user=request.user)[0]
            item = cart.items.filter(product__id=product_id, user=request.user).first()

            if item:
                item.quantity = quantity
                item.save()
                return Response(CartItemSerializer(item, context={'request': request}).data, status=status.HTTP_200_OK)
            else:
                return Response({"detail": "Item not found in cart."}, status=status.HTTP_404_NOT_FOUND)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ClearCartView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        cart = ShoppingCart.objects.get_or_create(user=request.user)[0]
        cart.items.all().delete()
        cart.items.clear()
        return Response({"detail": "Cart cleared."}, status=status.HTTP_200_OK)
#-------<likes List>-------------
# 1. Add Likeslist (AddLikesListEvent)
class AddLikeslistView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        title = request.data.get("title")
        if not title:
            return Response({"error": "Title is required"}, status=status.HTTP_400_BAD_REQUEST)

        # Create the likes list
        likeslist = Likeslist.objects.create(title=title, user=request.user)
        return Response(LikeslistSerializer(likeslist).data, status=status.HTTP_201_CREATED)


# 2. Remove Likeslist (RemoveLikesListEvent)
class RemoveLikeslistView(APIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request, likeslist_id):
        # Find the likes list and delete it
        likeslist = get_object_or_404(Likeslist, id=likeslist_id, user=request.user)
        likeslist.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


# 3. Add Product to Likeslist (AddProductEvent)
class AddProductToLikeslistView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, likeslist_id):
        likeslist = get_object_or_404(Likeslist, id=likeslist_id, user=request.user)
        product_id = request.data.get("product_id")

        if not product_id:
            return Response({"error": "Product ID is required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            # Check if the product exists
            product = Product.objects.get(id=product_id)
        except Product.DoesNotExist:
            return Response({"error": "Product not found."}, status=status.HTTP_404_NOT_FOUND)

        # Check if the product is already in the likes list to prevent duplicates
        if product in likeslist.products.all():
            return Response({"error": "Product already in the likes list."}, status=status.HTTP_400_BAD_REQUEST)

        # Add the product to the likes list
        likeslist.products.add(product)
        return Response(LikeslistSerializer(likeslist, context={'request': request}).data, status=status.HTTP_200_OK)


# 4. Remove Product from Likeslist (RemoveProductEvent)
class RemoveProductFromLikeslistView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, likeslist_id):
        likeslist = get_object_or_404(Likeslist, id=likeslist_id, user=request.user)
        product_id = request.data.get("product_id")

        if not product_id:
            return Response({"error": "Product ID is required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            # Check if the product exists
            product = Product.objects.get(id=product_id)
        except Product.DoesNotExist:
            return Response({"error": "Product not found."}, status=status.HTTP_404_NOT_FOUND)

        # Remove the product from the likes list
        likeslist.products.remove(product)
        return Response(LikeslistSerializer(likeslist, context={'request': request}).data, status=status.HTTP_200_OK)


# 5. Refresh Likeslists (RefreshLikesLists)
class ListLikeslistsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        likeslists = Likeslist.objects.filter(user=request.user)
        serializer = LikeslistSerializer(likeslists, many=True, context={'request': request})
        return Response(serializer.data)
#-------<liked Stores>-------------
class LikedStoresView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        liked, _ = LikedStores.objects.get_or_create(user=request.user)
        serializer = LikedStoresSerializer(liked, context={"request": request})
        return Response(serializer.data)


class AddStoreToLikedView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        store_id = request.data.get("store_id")
        if not store_id:
            return Response({"error": "Store ID is required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            store = Store.objects.get(id=store_id)
        except Store.DoesNotExist:
            return Response({"error": "Store not found"}, status=status.HTTP_404_NOT_FOUND)

        liked, _ = LikedStores.objects.get_or_create(user=request.user)
        liked.stores.add(store)
        serializer = LikedStoresSerializer(liked, context={"request": request})
        return Response(serializer.data, status=status.HTTP_200_OK)


class RemoveStoreFromLikedView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        store_id = request.data.get("store_id")
        if not store_id:
            return Response({"error": "Store ID is required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            store = Store.objects.get(id=store_id)
        except Store.DoesNotExist:
            return Response({"error": "Store not found"}, status=status.HTTP_404_NOT_FOUND)

        liked, _ = LikedStores.objects.get_or_create(user=request.user)
        liked.stores.remove(store)
        serializer = LikedStoresSerializer(liked, context={"request": request})
        return Response(serializer.data, status=status.HTTP_200_OK)
#-------<Review>-------------
class ReviewListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, store_id):

        reviews = Review.objects.filter(store__id=store_id)
        serializer = ReviewSerializer(reviews, many=True)
        return Response(serializer.data)

class ReviewCreateView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, store_id):
     
        data = request.data
        data['store'] = store_id
        data['user'] = request.user.id  
        serializer = ReviewSerializer(data=data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ReviewDeleteView(APIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request, store_id, review_id):
   
        try:
            review = Review.objects.get(store__id=store_id, id=review_id, user=request.user)
            review.delete()
            return JsonResponse({"message": "Review deleted successfully"}, status=status.HTTP_204_NO_CONTENT)
        except Review.DoesNotExist:
            return JsonResponse({"message": "Review not found or not authorized to delete."}, status=status.HTTP_404_NOT_FOUND)
#-------<Order>-------------
class CreateOrderView(generics.CreateAPIView):
    serializer_class = OrderSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class UpdateOrderStatusView(APIView):
    permission_classes = [IsAuthenticated]

    def patch(self, request, pk):
        try:
            order = Order.objects.get(pk=pk)
            if order.user != request.user and not request.user.is_staff:
                return Response({"detail": "Permission denied."}, status=status.HTTP_403_FORBIDDEN)
            
            new_status = request.data.get("status")
            if new_status not in dict(Order.STATUS_CHOICES):
                return Response({"detail": "Invalid status."}, status=status.HTTP_400_BAD_REQUEST)

            order.status = new_status
            order.save()
            return Response({"detail": "Order status updated."})
        except Order.DoesNotExist:
            return Response({"detail": "Order not found."}, status=status.HTTP_404_NOT_FOUND)
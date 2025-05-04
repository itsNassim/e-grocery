from rest_framework import serializers


from .models import *

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = CustomUser
        fields = ['email', 'full_name', 'phone_number', 'password']

    def create(self, validated_data):
        return CustomUser.objects.create_user(**validated_data)


class UserUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ["id", 'full_name', 'email', 'phone_number']


class CategorySerializer(serializers.ModelSerializer):
    image = serializers.SerializerMethodField()

    class Meta:
        model = Category
        fields = ['id', 'name', 'image']

    def get_image(self, obj):
        request = self.context.get('request')
        if request:
            return request.build_absolute_uri(obj.image.url)
        return obj.image.url


class StoreSerializer(serializers.ModelSerializer):
    image = serializers.SerializerMethodField()

    class Meta:
        model = Store
        fields = ['id','name', 'email', 'phone', 'address', 'opening_time', 'closing_time', 'image']

    def get_image(self, obj):
        request = self.context.get('request')
        if request:
            return request.build_absolute_uri(obj.image.url)
        return obj.image.url


class ProductSerializer(serializers.ModelSerializer):
    category = CategorySerializer(read_only=True)
    store = StoreSerializer(read_only=True)
    image = serializers.SerializerMethodField()

    class Meta:
        model = Product
        fields = '__all__'

    def get_image(self, obj):
        request = self.context.get('request')
        if obj.image and request:
            return request.build_absolute_uri(obj.image.url)
        return None

#Shopping cart
class CartItemSerializer(serializers.ModelSerializer):
    product = ProductSerializer()

    class Meta:
        model = CartItem
        fields = ['id', 'product', 'quantity']

class AddCartItemSerializer(serializers.Serializer):
    product_id = serializers.IntegerField()
    quantity = serializers.IntegerField(min_value=1)

class UpdateCartItemSerializer(serializers.Serializer):
    product_id = serializers.IntegerField()
    quantity = serializers.IntegerField(min_value=1)

class ShoppingCartSerializer(serializers.ModelSerializer):
    items = CartItemSerializer(many=True)

    class Meta:
        model = ShoppingCart
        fields = ['user', 'items']

#likes list
class LikeslistSerializer(serializers.ModelSerializer):
    products = ProductSerializer(many=True, read_only=True)
    product_ids = serializers.PrimaryKeyRelatedField(
        queryset=Product.objects.all(),
        many=True,
        write_only=True,
        source='products'
    )

    class Meta:
        model = Likeslist
        fields = ['id', 'title', 'user', 'products', 'product_ids']


#liked Stores
class LikedStoresSerializer(serializers.ModelSerializer):
    stores = StoreSerializer(many=True, read_only=True)

    class Meta:
        model = LikedStores
        fields = ['id', 'stores']

#review
class ReviewSerializer(serializers.ModelSerializer):
    user = UserUpdateSerializer(read_only=True)

    class Meta:
        model = Review
        fields = ['id', 'user', 'text', 'rating']


#order
class OrderItemSerializer(serializers.ModelSerializer):
    product = ProductSerializer(read_only=True)  
    product_id = serializers.PrimaryKeyRelatedField(queryset=Product.objects.all(), write_only=True)  

    class Meta:
        model = OrderItem
        fields = ['product', 'product_id', 'quantity', 'price']

class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True)
    date = serializers.DateTimeField(format="%Y-%m-%d", read_only=True)
    
    class Meta:
        model = Order
        fields = ['id','user', 'status', 'payment_method', 'date', 'items']
        read_only_fields = ['id', 'status']  

    def create(self, validated_data):
        items_data = validated_data.pop('items')
        order = Order.objects.create(**validated_data)
        for item_data in items_data:
            product = item_data.pop('product_id')  # extract product_id
            OrderItem.objects.create(order=order, product=product, **item_data)
        return order

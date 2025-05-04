from django.urls import path
from .views import *
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path('signup/', RegisterView.as_view(), name='signup'),
    path('login/', TokenObtainPairView.as_view(), name='login'),
    path('refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('token_info/', GetUserInfoView.as_view(), name='token_info'),
    #------------<Profile>------------
    path('update-user/', update_user_info, name='update_user_info'),
    path("change-password/", ChangePasswordView.as_view(), name="change-password"),
    path("delete-account/", DeleteAccountView.as_view(), name="delete-account"),
    #-------------<Category>----------
    path('categories/', get_all_categories, name='get_all_categories'),
    #-------------<Store>----------
    path('stores/', get_all_stores, name='get_all_stores'),
    #-------------<Product>----------
    path('products/', get_all_products, name='get_all_products'),
    #-------------<Shopping Cart>---------- 
    path("cart/", ShoppingCartView.as_view(), name="cart"),
    path("cart/add/", AddToCartView.as_view(), name="add_to_cart"),
    path("cart/remove/<int:product_id>/", RemoveFromCartView.as_view(), name="remove_from_cart"),
    path("cart/update/", UpdateCartItemQuantityView.as_view(), name="update_cart_item"),
    path("cart/clear/", ClearCartView.as_view(), name="clear_cart"),
    #-------------<Likes List>---------- 
    path('likeslists/', ListLikeslistsView.as_view()),
    path('likeslists/add/', AddLikeslistView.as_view()),
    path('likeslists/<int:likeslist_id>/remove/', RemoveLikeslistView.as_view()),
    path('likeslists/<int:likeslist_id>/add_product/', AddProductToLikeslistView.as_view()),
    path('likeslists/<int:likeslist_id>/remove_product/', RemoveProductFromLikeslistView.as_view()),
    #-------------<Likes List>---------- 
    path('likedstores/', LikedStoresView.as_view(), name='likedstores'),
    path('likedstores/add/', AddStoreToLikedView.as_view(), name='add_likedstore'),
    path('likedstores/remove/', RemoveStoreFromLikedView.as_view(), name='remove_likedstore'),
    #-------------<Review>---------- 
    path('stores/<int:store_id>/reviews/', ReviewListView.as_view(), name='store-reviews'),
    path('stores/<int:store_id>/reviews/add/', ReviewCreateView.as_view(), name='add-review'),
    path('stores/<int:store_id>/reviews/<int:review_id>/delete/', ReviewDeleteView.as_view(), name='delete-review'),
    #-------------<Order>---------- 
    path('orders/', UserOrdersView.as_view(), name='user-orders'),
    path('orders/create/', CreateOrderView.as_view(), name='create-order'),
    path('orders/<int:pk>/update-status/', UpdateOrderStatusView.as_view(), name='update-order-status'),
    #-------------<Product Filter>---------- 
    path('products/filter/', ProductFilterView.as_view(), name='product-list'),
    #-------------<Search>---------- 
    path('search/', search_view, name='search'),


]

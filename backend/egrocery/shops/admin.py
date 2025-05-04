from django.contrib import admin
from .models import *

@admin.register(CustomUser)
class CustomUserAdmin(admin.ModelAdmin):
    list_display = ("id", "full_name", "email",  "phone_number")  
    search_fields = ("email", "full_name")

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ("id", "name")

@admin.register(Store)
class StoreAdmin(admin.ModelAdmin):
    list_display = ("id", "name", "email", "phone", "opening_time", "closing_time")
    search_fields = ("name",)

@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ("id", "name", "price", "weight", "category", "store")
    list_filter = ("category", "store", "price")
    search_fields = ("name", "base_slug")

@admin.register(CartItem)
class CartItemAdmin(admin.ModelAdmin):
    list_display = ("user", "product", "quantity")
    list_filter = ("product",)
   

@admin.register(ShoppingCart)
class ShoppingCartAdmin(admin.ModelAdmin):
    list_display = ("user",)
    list_filter = ("user",)


@admin.register(Likeslist)
class LikeslistAdmin(admin.ModelAdmin):
    list_display = ("user","title")
    list_filter = ("user",)

@admin.register(LikedStores)
class LikedStoresAdmin(admin.ModelAdmin):
    list_display = ('user', 'store_count')
    search_fields = ('user__full_name', 'user__email')
    filter_horizontal = ('stores',)

    def store_count(self, obj):
        return obj.stores.count()
    store_count.short_description = 'Number of Liked Stores'
    
@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    def user_full_name(self, obj):
        return obj.user.full_name if obj.user else "No User"
    user_full_name.short_description = 'User Full Name' 

    list_display = ("user_full_name","store","rating")
    list_filter = ("user","store")


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    def user_full_name(self, obj):
        return obj.user.full_name if obj.user else "No User"
    user_full_name.short_description = 'User Full Name'

    list_display = ("id", "user_full_name", "status", "payment_method", "date")
    list_filter = ("status", "payment_method", "user")


@admin.register(OrderItem)
class OrderItemAdmin(admin.ModelAdmin):
    def user_full_name(self, obj):
        return obj.order.user.full_name if obj.order and obj.order.user else "No User"
    user_full_name.short_description = 'User Full Name'

    list_display = ("user_full_name", "product", "quantity", "price", "order")
    list_filter = ("order__user", "product")
    

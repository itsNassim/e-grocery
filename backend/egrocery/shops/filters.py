import django_filters
from .models import Product

class ProductFilter(django_filters.FilterSet):
    price_min = django_filters.NumberFilter(field_name="price", lookup_expr='gte')
    price_max = django_filters.NumberFilter(field_name="price", lookup_expr='lte')
    ordering = django_filters.OrderingFilter(
        fields=(('name', 'name'),),
        field_labels={'name': 'Alphabetical'},
        label='Sort by name'
    )

    class Meta:
        model = Product
        fields = ['category', 'store']

class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    render json: {
      data: Product.all.as_json
    }
  end

  def add_to_cart
    product = Product.find_by_id(params[:product_id])
    unless current_user.cart_products.where(product_id: product.id)
      cart_product = product.cart_products.new(cart: current_user.cart)
      if cart_product.save
        render json: {
          messages: "added Successfully",
          is_success: true,
          data: {product: product}
        }, status: :ok
      else
        render json: {
          messages: cart_product.errors.full_messages.to_sentence,
          is_success: false,
        }, status: :unprocessable_entity
      end
    else
      render json: {
          messages: 'Product already exists in your cart',
          is_success: false,
        }, status: :ok
    end
  end

  def cart_products
    render json: {
      data: current_user.cart.products.as_json
    }
  end
end

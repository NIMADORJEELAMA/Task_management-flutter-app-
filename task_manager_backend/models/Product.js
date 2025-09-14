import mongoose from "mongoose";

const productSchema = new mongoose.Schema({
  site: String,
  product_url: String,
  keyword_id: String, // links to your keyword's id field
  keyword: String,
  product_id: { type: String, required: true },
  brand_name: String,
  product_name: String,
  product_rating: String,
  product_rating_count: String,
  current_product_price: String,
  original_product_price: String,
  product_color: String,
  product_description: String,
  product_sizes_available: [String],
  product_sizes_coming_soon: [String],
  product_sizes_out_of_stock: [String],
  product_image_urls: [String],
  additional_information: String,
});

export default mongoose.model("Product", productSchema, "products");

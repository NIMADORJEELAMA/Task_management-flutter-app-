import mongoose from "mongoose";

const keywordSchema = new mongoose.Schema({
  id: { type: String }, // JSON field
  keyword: { type: String, required: true },
  category: { type: String },
  subcategory: { type: String },
});

export default mongoose.model("Keyword", keywordSchema, "keywords");

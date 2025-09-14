import mongoose from "mongoose";

const taskSchema = new mongoose.Schema(
  {
    title: { type: String, required: true },
    completed: { type: Boolean, default: false },
    keywordId: { type: mongoose.Schema.Types.ObjectId, ref: "Keyword" },
  },
  { timestamps: true }
);

export default mongoose.model("Task", taskSchema);

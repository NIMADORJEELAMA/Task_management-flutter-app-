import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import cors from "cors";

import taskRoutes from "./routes/task.routes.js";
import keywordRoutes from "./routes/keyword.routes.js";
import productRoutes from "./routes/product.routes.js";

dotenv.config();
const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use("/api/tasks", taskRoutes);
app.use("/api/keywords", keywordRoutes);
app.use("/api/products", productRoutes);

// DB connection
mongoose
  .connect(process.env.MONGO_URI)
  .then(() => {
    console.log("MongoDB connected ✅");
    // app.listen(process.env.PORT || 5000, () =>
    //   console.log(`Server running on port ${process.env.PORT || 5000}`)
    // );
    // ...existing code...
    app.listen(process.env.PORT || 5000, "0.0.0.0", () =>
      console.log(`Server running on port ${process.env.PORT || 5000}`)
    );
    // ...existing code...
  })
  .catch((err) => console.error("MongoDB connection error:", err));

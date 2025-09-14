import express from "express";
import {
  getProductsByKeyword,
  getProductById,
} from "../controllers/product.controller.js";

const router = express.Router();

router.get("/", getProductsByKeyword); // /api/products?keyword=<keywordId>
router.get("/:id", getProductById);

export default router;

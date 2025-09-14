import Product from "../models/Product.js";

// GET /api/products?keyword=<keywordId>
export const getProductsByKeyword = async (req, res) => {
  try {
    const { keyword } = req.query;
    console.log("➡️ Keyword query received:", keyword); // 👀 DEBUG

    if (!keyword) {
      return res.status(400).json({ error: "keyword query param is required" });
    }

    const products = await Product.find({ keyword_id: keyword });

    console.log("✅ Products found:", products.length); // 👀 DEBUG
    res.json(products);
  } catch (err) {
    console.error("❌ Server error:", err.message);
    res.status(500).json({ error: err.message });
  }
};

// export const getProductsByKeyword = async (req, res) => {
//   try {
//     const { keyword } = req.query;

//     if (!keyword) {
//       return res.status(400).json({ error: "keyword query param is required" });
//     }

//     // find all products that match keyword_id
//     const products = await Product.find({ keyword_id: keyword });

//     res.json(products);
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// };

// GET /api/products/:id
export const getProductById = async (req, res) => {
  try {
    console.log("Looking for product_id:", req.params.id);

    const product = await Product.findOne({ product_id: req.params.id });

    if (!product) {
      console.log("No match found");
      return res.status(404).json({ error: "Product not found" });
    }

    console.log("Product found:", product);
    res.json(product);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

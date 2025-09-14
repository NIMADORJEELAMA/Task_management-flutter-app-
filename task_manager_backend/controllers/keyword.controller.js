import Keyword from "../models/Keyword.js";

export const getKeywords = async (req, res) => {
  try {
    const keywords = await Keyword.find();

    res.json(keywords);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// pages/api/proxy-login.js
import axios from 'axios';

export default async function handler(req, res) {
  if (req.method === 'POST') {
    try {
      const response = await axios.post('https://14.225.210.16:8081/api/auth/login', req.body, {
        headers: {
          'Content-Type': 'application/json',
        },
      });
      res.status(response.status).json(response.data);
    } catch (error) {
        console.log("haha")
      res.status(error.response?.status || 500).json(error.response?.data || { message: 'Internal Server Error' });
    }
  } else {
    res.setHeader('Allow', ['POST']);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}

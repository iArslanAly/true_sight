# TrueSight – AI Media Authenticity Verifier 🛡️

TrueSight is a media verification app that detects AI-generated (deepfake) images and videos using Reality Defender’s cutting-edge SDKs. Built as a portfolio project, it showcases integration with external AI detection services to fight misinformation and promote content authenticity.

---

## 🔍 Features

- ✅ Detect AI-generated content in images and videos
- 🔄 Upload media files via mobile or web interface
- 📊 Display detection confidence score and result status
- 🧠 Integrated with **Reality Defender SDK**
- 💬 Clean, intuitive UI/UX with real-time feedback
- 🧾 Optional detection history for previously scanned media

---

## 🛠️ Tech Stack

| Layer        | Technology            |
|--------------|------------------------|
| Frontend     | Flutter (Mobile-first UI) |
| Backend      | Node.js + Express (API Server) |
| AI Detection | Reality Defender SDK (Node or Python) |
| State Mgmt   | Flutter BLoC (Optional) |
| Hosting      | Vercel/Render/Heroku (for backend) |

---

## 🚀 How It Works

1. **User Uploads** an image or video from their device.
2. **Media is sent** to the backend server securely.
3. **Reality Defender SDK** analyzes the content.
4. **Detection Result** is returned and displayed (Real / Fake).
5. **Optional**: Save detection history locally or in the cloud.

---

## 📦 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/iarslanaly/truesight.git
cd truesight
```

### 2. Set Up Backend (Node.js Example)

```bash
cd backend
npm install
# Add your Reality Defender API key in `.env`
node index.js
```

### 3. Set Up Flutter Frontend

```bash
cd flutter_app
flutter pub get
flutter run
```

### 🧪 SDK Usage (Reality Defender Example)

```js
Copy
Edit
// Node.js Example using Reality Defender SDK
const RD = require('@realitydefender/sdk');

const rd = new RD({ apiKey: 'YOUR_API_KEY' });

const result = await rd.detectImage({
  imageUrl: 'https://example.com/image.jpg',
});

console.log(result.status, result.confidenceScore);
```

### 🎯 Why TrueSight?

Deepfakes and AI-generated media are growing threats. This app is designed as a portfolio-grade solution to explore:

Real-world SDK integration

API-based AI verification

Secure media handling

UI/UX for trust-based apps

### 📄 License

MIT License – Feel free to fork, modify, and contribute.

### 🙋‍♂️ Author

Arslan Ali
UI/UX Designer & Flutter Developer
Portfolio | LinkedIn | Upwork

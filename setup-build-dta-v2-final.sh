#!/bin/bash
# Complete setup and ZIP builder for DivineTruthAscension-v2

BACKUP=~/divinetruthascension-backup
V2=~/divinetruthascension-v2
ZIP=~/divinetruthascension-v2.zip

# 1️⃣ Create folder structure
mkdir -p $V2/src/css $V2/src/js $V2/public/images

# 2️⃣ Copy backup files
cp -r $BACKUP/css/* $V2/src/css/
cp -r $BACKUP/js/* $V2/src/js/
cp -r $BACKUP/images/* $V2/public/images/
cp $BACKUP/index.html $V2/public/

# 3️⃣ Add React/Vite starter files
cat > $V2/src/App.jsx << 'APP'
import React from 'react';
import './css/styles.css';

function App() {
  return (
    <div>
      <h1>DivineTruthAscension-v2</h1>
      <p>Your platform is ready!</p>
    </div>
  );
}

export default App;
APP

cat > $V2/src/main.jsx << 'MAIN'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
MAIN

# 4️⃣ Firebase.js using .env
cat > $V2/src/firebase.js << 'FIREBASE'
import { initializeApp } from 'firebase/app';
import { getAuth, GoogleAuthProvider } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: `${process.env.FIREBASE_PROJECT_ID}.firebaseapp.com`,
  projectId: process.env.FIREBASE_PROJECT_ID,
  storageBucket: `${process.env.FIREBASE_PROJECT_ID}.appspot.com`,
  messagingSenderId: process.env.FIREBASE_SENDER_ID,
  appId: process.env.FIREBASE_APP_ID
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const provider = new GoogleAuthProvider();
export const db = getFirestore(app);
FIREBASE

# 5️⃣ package.json
cat > $V2/package.json << 'PKG'
{
  "name": "divinetruthascension-v2",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "vite --host --port $PORT",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "firebase": "^11.1.0"
  },
  "devDependencies": {
    "vite": "^5.0.0",
    "@vitejs/plugin-react": "^4.0.0"
  }
}
PKG

# 6️⃣ vite.config.js
cat > $V2/vite.config.js << 'VITE'
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: { host: true, port: 5173 }
});
VITE

# 7️⃣ .gitignore
cat > $V2/.gitignore << 'GIT'
node_modules/
dist/
npm-debug.log*
.replit
GIT

# 8️⃣ .replit config
cat > $V2/.replit << 'REPLIT'
run = "npm run dev"
language = "nodejs"
REPLIT

# 9️⃣ .env placeholders
cat > $V2/.env << 'ENV'
PORT=5173
FIREBASE_API_KEY=YOUR_API_KEY
FIREBASE_PROJECT_ID=YOUR_PROJECT_ID
FIREBASE_APP_ID=YOUR_APP_ID
FIREBASE_SENDER_ID=YOUR_SENDER_ID
ENV

# 10️⃣ Create ZIP
cd ~
zip -r $ZIP $(basename $V2)
echo "✅ Complete! divinetruthascension-v2.zip created at $ZIP"

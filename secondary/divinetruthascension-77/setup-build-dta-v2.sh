#!/bin/bash
# All-in-one setup and ZIP builder for DivineTruthAscension-v2

BACKUP=~/divinetruthascension-backup
V2=~/divinetruthascension-v2
ZIP=~/divinetruthascension-v2.zip

mkdir -p $V2/src/css $V2/src/js $V2/public/images

cp -r $BACKUP/css/* $V2/src/css/
cp -r $BACKUP/js/* $V2/src/js/
cp -r $BACKUP/images/* $V2/public/images/
cp $BACKUP/index.html $V2/public/

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

cat > $V2/src/firebase.js << 'FIREBASE'
import { initializeApp } from 'firebase/app';
import { getAuth, GoogleAuthProvider } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_PROJECT_ID.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID"
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const provider = new GoogleAuthProvider();
export const db = getFirestore(app);
FIREBASE

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

cat > $V2/vite.config.js << 'VITE'
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: { host: true, port: 5173 }
});
VITE

cat > $V2/.gitignore << 'GIT'
node_modules/
dist/
npm-debug.log*
.replit
GIT

cd ~
zip -r $ZIP $(basename $V2)
echo "✅ Setup complete! ZIP ready at $ZIP"

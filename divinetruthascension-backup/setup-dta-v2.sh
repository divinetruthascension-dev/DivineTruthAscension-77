#!/bin/bash
# Setup DivineTruthAscension-v2 folder structure and starter template

# Paths
BACKUP=~/divinetruthascension-backup
V2=~/divinetruthascension-v2

# Create folder structure
mkdir -p $V2/src/css $V2/src/js $V2/public/images

# Copy backup files
cp -r $BACKUP/css/* $V2/src/css/
cp -r $BACKUP/js/* $V2/src/js/
cp -r $BACKUP/images/* $V2/public/images/
cp $BACKUP/index.html $V2/public/

# Create starter React/Vite files
cat > $V2/src/App.jsx << 'EOF'
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
EOF

cat > $V2/src/main.jsx << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF

cat > $V2/src/firebase.js << 'EOF'
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
EOF

# package.json
cat > $V2/package.json << 'EOF'
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
EOF

# vite.config.js
cat > $V2/vite.config.js << 'EOF'
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: { host: true, port: 5173 }
});
EOF

# .gitignore
cat > $V2/.gitignore << 'EOF'
node_modules/
dist/
npm-debug.log*
.replit
EOF

echo "DivineTruthAscension-v2 setup completed in $V2"
#!/bin/bash
# Create a ZIP of the prepared DivineTruthAscension-v2 folder

V2=~/divinetruthascension-v2
ZIP=~/divinetruthascension-v2.zip

cd ~
zip -r $ZIP $(basename $V2)

echo "ZIP created at $ZIP"

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
chmod +x setup-dta-v2.sh
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

# Create a ZIP of the prepared DivineTruthAscension-v2 folder
V2=~/divinetruthascension-v2
ZIP=~/divinetruthascension-v2.zip
cd ~
zip -r $ZIP $(basename $V2)
echo "ZIP created at $ZIP"
chmod +x setup-dta-v2.sh build-dta-v2-zip.sh
./setup-dta-v2.sh
cd ~/divinetruthascension-v2
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

# Create a ZIP of the prepared DivineTruthAscension-v2 folder
V2=~/divinetruthascension-v2
ZIP=~/divinetruthascension-v2.zip
cd ~
zip -r $ZIP $(basename $V2)
echo "ZIP created at $ZIP"chmod +x setup-dta-v2.sh build-dta-v2-zip.sh
./setup-dta-v2.sh
cd ~/divinetruthascension-v2
./setup-dta-v2.sh
./build-dta-v2-zip.sh
cd
./setup-dta-v2.sh
./build-dta-v2-zip.sh
~/divinetruthascension-v2 ZIP
cd ~/divinetruthascension-v2
npm install
nano ~/setup-build-dta-v2.sh
chmod +x ~/setup-build-dta-v2.sh
./setup-build-dta-v2.sh
cd ~
nano setup-build-dta-v2.sh
chmod +x ~/setup-build-dta-v2.sh
./setup-build-dta-v2.sh
npm install
npm run dev
cat > ~/setup-build-dta-v2.sh << 'EOF'
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
EOF

chmod +x ~/setup-build-dta-v2.sh
~/setup-build-dta-v2.sh
.git/hooks
cd
pkg update && pkg install git -y
cd ~
git clone https://github.com/divinetruthascension-dev/divinetruthascension-v2.git
cd divinetruthascension-v2
git pull
git remote -v
git branch -r
# Set local branch to track GitHub master
git branch --set-upstream-to=origin/master master
# Pull the latest changes
git pull
# Fetch all branches and updates from GitHub
git fetch origin
# Make sure your local branch is master
git checkout master
# Set local master to track remote master
git branch --set-upstream-to=origin/master master
# Now pull the latest changes
git pull
git checkout master
git fetch origin
# In Replit Shell
git init
git add .
git commit -m "Push from Replit"
git branch -M master
git remote add origin https://github.com/divinetruthascension-dev/divinetruthascension-v2.git
git push -u origin master --force
pkg install git -y
cd ~
git clone https://github.com/divinetruthascension-dev/divinetruthascension-v2.git
cd divinetruthascension-v2pkg update
pkg install git
cd ~/storage/shared/divinetruthascension-v2
cd ~/divinetruthascension-v2
ls -a
git init
git add .
git commit -m "Pulled v2 from Replit"
push_v2.sh
nano cleanup_branches.sh
chmod +x cleanup_branches.sh
./cleanup_branches.sh
# --- Configuration ---
REPO_DIR="$HOME/storage/shared/divinetruthascension-v2"
GITHUB_REPO="https://github.com/<username>/divinetruthascension-v2.git"  # Replace with your repo
# --- Step 1: Navigate to the repo ---
cd "$REPO_DIR" || { echo "Repo not found!"; exit 1; }
package (copy).json
cd ~/storage/shared/divinetruthascension-v2
git fetch --all
git branch -a
cd ~/storage/shared/divinetruthascension-v2
git fetch --all
git branch -a
cd~/divinetruthascension-v2
cd ~/divinetruthascension-v2
cd ~/storage/shared/divinetruthascension-v2
git fetch --all
git branch -a
# Make sure you are on main
git checkout main
# Merge master
git merge master
# Merge Master (if different)
git merge Master
git branch -d master
git branch -d Master
git push origin --delete master
git push origin --delete Master
git push -u origin main
./cleanup_branches.sh
#!/bin/bash
# --- Configuration ---
REPO_DIR="$HOME/storage/shared/divinetruthascension-v2"
GITHUB_REPO="https://github.com/<username>/divinetruthascension-v2.git"  # Replace with your repo
# --- Step 1: Navigate to the repo ---
cd "$REPO_DIR" || { echo "Repo not found!"; exit 1; }
cd ~/storage/shared/divinetruthascension-v2
git fetch --all
git branch -a
cd ~/storage/shared/divinetruthascension-v2
cd ~/divinetruthascension-v2 
ls -a
git init
git add .
git commit -m "Initial commit from Replit"
git fetch origin
git branch -a
~/cleanup_v2_branches.sh #!/bin/bash
# --- Configuration ---
REPO_DIR="$HOME/storage/shared/divinetruthascension-v2"
GITHUB_REPO="https://github.com/<username>/divinetruthascension-v2.git"  # Replace with your repo URL
# --- Step 1: Navigate to the project folder ---
cd "$REPO_DIR" || { echo "Repo folder not found!"; exit 1; }
cd ~/storage/shared/divinetruthascension-v2
cd ~/divinetruthascension-v2
nano ~/cleanup_v2_branches.sh
chmod +x cleanup_v2_branches.sh
cd ~/cleanup_v2_branches.sh
ls -a
git init
git add .
git commit -m "Initial commit from Replit"
git fetch origin
git branch -a
#!/bin/bash/cleanup_v2_branches.sh
# --- Configuration ---
REPO_DIR="$HOME/storage/shared/divinetruthascension-v2"
GITHUB_REPO="https://github.com/div divinetruthascension-dev.git"  # Replace with your repo URL
# --- Step 1: Navigate to the project folder ---
cd "$REPO_DIR" || { echo "Repo folder not found!"; exit 1; }

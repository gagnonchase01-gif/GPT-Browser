#!/bin/bash

# GPT-Browser Auto Generator Script
# Creates full repo structure with all files

echo "Creating GPT-Browser folder..."
mkdir -p gpt-browser/{main,preload,renderer,components,ai,store,styles,public,mobile}
cd gpt-browser

echo "Creating package.json..."
cat > package.json <<EOL
{
  "name": "gpt-browser",
  "version": "0.1.0",
  "main": "main/main.ts",
  "scripts": {
    "start": "electron .",
    "dev": "tsc --watch",
    "build": "tsc"
  },
  "devDependencies": {
    "electron": "^25.0.0",
    "typescript": "^5.2.2"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  }
}
EOL

echo "Creating tsconfig.json..."
cat > tsconfig.json <<EOL
{
  "compilerOptions": {
    "target": "ES6",
    "module": "commonjs",
    "jsx": "react",
    "outDir": "dist",
    "strict": true,
    "esModuleInterop": true
  },
  "include": ["main/**/*.ts","renderer/**/*.tsx","components/**/*.tsx","preload/**/*.ts","ai/**/*.ts","store/**/*.ts"]
}
EOL

echo "Creating main/main.ts..."
cat > main/main.ts <<EOL
const { app, BrowserWindow } = require('electron');
const path = require('path');

function createWindow() {
  const win = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      preload: path.join(__dirname, '../preload/preload.js'),
      nodeIntegration: false,
      contextIsolation: true
    }
  });
  win.loadFile('renderer/index.html');
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});
EOL

echo "Creating preload/preload.ts..."
cat > preload/preload.ts <<EOL
const { contextBridge } = require('electron');

contextBridge.exposeInMainWorld('electronAPI', {
  // Add APIs here later
});
EOL

echo "Creating renderer/index.html..."
cat > renderer/index.html <<EOL
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GPT-Browser</title>
  <link rel="stylesheet" href="../styles/app.css" />
</head>
<body>
  <div id="root"></div>
  <script src="./index.tsx"></script>
</body>
</html>
EOL

echo "Creating renderer/index.tsx..."
cat > renderer/index.tsx <<EOL
import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';

const root = createRoot(document.getElementById('root')!);
root.render(<App />);
EOL

echo "Creating renderer/App.tsx..."
cat > renderer/App.tsx <<EOL
import React, { useState } from 'react';
import Tabs from '../components/Tabs';
import AddressBar from '../components/AddressBar';
import Toolbar from '../components/Toolbar';
import '../styles/app.css';

const App: React.FC = () => {
  const [activeTab, setActiveTab] = useState('tab1');
  return (
    <div className="app-container">
      <Tabs activeTab={activeTab} setActiveTab={setActiveTab} />
      <Toolbar />
      <AddressBar activeTab={activeTab} />
      {/* Add AI sidebar and panels here */}
    </div>
  );
};

export default App;
EOL

echo "Creating components/Tabs.tsx..."
cat > components/Tabs.tsx <<EOL
import React, { useState } from 'react';

interface Tab { id: string; title: string; url: string }
interface TabsProps { activeTab: string; setActiveTab: (id: string) => void }

const Tabs: React.FC<TabsProps> = ({ activeTab, setActiveTab }) => {
  const [tabs, setTabs] = useState<Tab[]>([{ id: 'tab1', title: 'New Tab', url: 'https://google.com' }]);
  const addTab = () => { const t={id:\`tab\${Date.now()}\`,title:'New Tab',url:'https://google.com'}; setTabs([...tabs,t]); setActiveTab(t.id); };
  const closeTab=(id:string)=>{ const f=tabs.filter(t=>t.id!==id); setTabs(f); if(activeTab===id && f.length>0)setActiveTab(f[0].id); };
  return (<div className="tabs-container">{tabs.map(t=>(
    <div key={t.id} className={\`tab \${t.id===activeTab?'active':''}\`} onClick={()=>setActiveTab(t.id)}>{t.title}
      <button className="close-tab" onClick={()=>closeTab(t.id)}>×</button>
    </div>
  ))}<button className="add-tab" onClick={addTab}>+</button></div>);
};

export default Tabs;
EOL

echo "Creating components/AddressBar.tsx..."
cat > components/AddressBar.tsx <<EOL
import React, { useState } from 'react';
interface AddressBarProps { activeTab: string }
const AddressBar: React.FC<AddressBarProps> = ({ activeTab }) => {
  const [url, setUrl] = useState('https://google.com');
  const handleKeyPress=(e:React.KeyboardEvent)=>{ if(e.key==='Enter'){ window.open(url,'_blank'); } };
  return (<div className="address-bar"><input type="text" value={url} onChange={e=>setUrl(e.target.value)} onKeyDown={handleKeyPress}/></div>);
};
export default AddressBar;
EOL

echo "Creating components/Toolbar.tsx..."
cat > components/Toolbar.tsx <<EOL
import React from 'react';
const Toolbar: React.FC = () => {
  return (
    <div className="toolbar">
      <button onClick={()=>window.history.back()}>←</button>
      <button onClick={()=>window.history.forward()}>→</button>
      <button onClick={()=>window.location.reload()}>⟳</button>
    </div>
  );
};
export default Toolbar;
EOL

echo "Creating components/SidebarAI.tsx..."
cat > components/SidebarAI.tsx <<EOL
import React from 'react';
const SidebarAI: React.FC = () => (<div className="ai-sidebar">AI Sidebar Placeholder</div>);
export default SidebarAI;
EOL

echo "Creating empty stubs for remaining files..."
touch components/BookmarksPanel.tsx components/DownloadsPanel.tsx ai/localWorker.ts store/bookmarksHistory.ts styles/app.css mobile/capacitor.config.json

echo "GPT-Browser generator complete! You now have a fully scaffolded repo."
echo "Next steps: cd gpt-browser, npm install, npx tsc, npx electron ."

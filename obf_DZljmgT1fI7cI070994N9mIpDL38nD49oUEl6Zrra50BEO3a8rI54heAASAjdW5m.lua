<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ScriptHub</title>
<style>
body { margin:0; font-family: Arial,sans-serif; background:#0a0a0a; color:white; }
header { display:flex; justify-content:center; align-items:center; padding:20px 0; background:#111; position:sticky; top:0; z-index:10; }
header h1 { font-size:2em; cursor:pointer; }

.hero { text-align:center; padding:40px 20px 20px; }
.hero h2 { font-size:2.5em; margin-bottom:10px; }
.hero p { color:#ccc; font-size:1.1em; }

.scripts-grid {
  display:grid;
  grid-template-columns:repeat(auto-fit,minmax(250px,1fr));
  gap:20px;
  padding:20px 50px;
}

.card {
  background:#111;
  border-radius:15px;
  overflow:hidden;
  transition:0.3s;
  cursor:pointer;
  display:flex;
  flex-direction:column;
  justify-content:space-between;
}

.card:hover { transform:scale(1.03); box-shadow:0 8px 20px rgba(250,204,21,0.3); }

.card img { width:100%; height:140px; object-fit:cover; border-bottom:1px solid #222; }

.card-content { padding:10px; display:flex; flex-direction:column; gap:6px; }
.card-content h3 { margin:0; font-size:1.1em; }

.status { width:12px; height:12px; border-radius:50%; display:inline-block; margin-right:6px; vertical-align:middle; }
.status.green { background:#22c55e; animation:pulseGreen 1.8s infinite; }
.status.yellow { background:#facc15; animation:flickerYellow 1s infinite; }
.status.red { background:#ef4444; animation:pulseRed 2.5s infinite; }
@keyframes pulseGreen {0%,100%{transform:scale(1);}50%{transform:scale(1.4);}}
@keyframes flickerYellow {0%,100%{opacity:1;}50%{opacity:0.4;}}
@keyframes pulseRed {0%,100%{transform:scale(1);}50%{transform:scale(1.3);}}

.star { position:absolute; top:8px; right:8px; font-size:18px; cursor:pointer; transition:0.3s; }
.star:hover { transform:scale(1.3); }

.view-btn {
  padding:8px 12px;
  border:none;
  border-radius:10px;
  font-weight:bold;
  cursor:pointer;
  background:linear-gradient(135deg,#facc15,#eab308);
  color:black;
  transition:0.3s;
  text-align:center;
}
.view-btn:hover { background:linear-gradient(135deg,#eab308,#ca8a04); color:white; transform:translateY(-1px); }

/* MODAL SKRYPTÓW */
.modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.95); justify-content:center; align-items:center; z-index:50; }
.modal-content { background:#111; padding:25px 35px; border-radius:15px; max-width:500px; width:90%; font-family:monospace; white-space:pre-wrap; text-align:center; }
.modal-content button { margin-top:15px; padding:10px 18px; border:none; border-radius:10px; cursor:pointer; font-weight:bold; transition:0.3s; background:linear-gradient(135deg,#facc15,#eab308); color:black; }
.modal-content button:hover { background:linear-gradient(135deg,#eab308,#ca8a04); color:white; }

/* MODAL LOGIN/REGISTER */
.login-modal { display:flex; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.98); justify-content:center; align-items:center; z-index:100; flex-direction:column; color:white; }
.login-box { background:#111; padding:30px 40px; border-radius:20px; max-width:400px; width:90%; text-align:center; }
.login-box input { width:100%; padding:10px 12px; margin:8px 0; border-radius:10px; border:none; background:#222; color:white; }
.login-box button { width:100%; margin-top:12px; padding:10px 12px; border:none; border-radius:12px; font-weight:bold; cursor:pointer; background:linear-gradient(135deg,#facc15,#eab308); color:black; transition:0.3s; }
.login-box button:hover { background:linear-gradient(135deg,#eab308,#ca8a04); color:white; }

footer { text-align:center; padding:30px; border-top:1px solid #222; color:#aaa; margin-top:50px; }
</style>
</head>
<body>

<header>
  <h1>ScriptHub</h1>
</header>

<section class="hero">
  <h2>Level Up Your Gameplay</h2>
  <p>Premium scripts • Constant updates • Ready for Roblox</p>
</section>

<section class="scripts-grid" id="scriptsGrid">
  <!-- cards JS -->
</section>

<!-- MODAL SCRIPT -->
<div class="modal" id="scriptModal">
  <div class="modal-content">
    <pre id="modalCode"></pre>
    <button onclick="copyCode()">Copy Script</button>
    <button onclick="closeModal()">Close</button>
  </div>
</div>

<!-- MODAL LOGIN -->
<div class="login-modal" id="loginModal">
  <div class="login-box">
    <h2>Login or Register</h2>
    <input type="text" id="username" placeholder="Username">
    <input type="email" id="email" placeholder="Email">
    <input type="password" id="password" placeholder="Password">
    <button onclick="login()">Login / Register</button>
    <p style="margin-top:10px; font-size:0.9em; color:#aaa;">After login, scripts will be unlocked!</p>
  </div>
</div>

<footer>© 2025 ScriptHub</footer>

<script>
const scripts = [
  {name:"Blox Fruits Auto Farm", game:"Blox Fruits", status:"green", code:'loadstring("blox.lua")', img:"https://tr.rbxcdn.com/180DAY-3b6e6c8c2c5e6b1f5c6b7c6d5e4f3a2b/768/432/Image/Webp/noFilter"},
  {name:"Arsenal Aimbot", game:"Arsenal", status:"yellow", code:'loadstring("arsenal.lua")', img:"https://via.placeholder.com/300"},
  {name:"MM2 ESP", game:"Murder Mystery 2", status:"red", code:'loadstring("mm2.lua")', img:"https://via.placeholder.com/300"}
];

function renderScripts(){
  const grid=document.getElementById('scriptsGrid');
  grid.innerHTML='';
  scripts.forEach((s,i)=>{
    const card=document.createElement('div');
    card.className='card';
    card.innerHTML=`
      <span class="star" onclick="toggleFav('${s.name}')">${localStorage.getItem(s.name)?"⭐":"☆"}</span>
      <img src="${s.img}">
      <div class="card-content">
        <h3>${s.name}</h3>
        <span class="status ${s.status}"></span> ${s.game}
        <button class="view-btn" onclick="viewScript(${i})">View Script</button>
      </div>
    `;
    grid.appendChild(card);
  });
}

function toggleFav(name){ 
  if(localStorage.getItem(name)){ localStorage.removeItem(name);}
  else{ localStorage.setItem(name,true);}
  renderScripts(); 
}

function viewScript(i){
  document.getElementById('modalCode').textContent=scripts[i].code;
  document.getElementById('scriptModal').style.display='flex';
}

function closeModal(){ document.getElementById('scriptModal').style.display='none'; }
function copyCode(){ navigator.clipboard.writeText(document.getElementById('modalCode').textContent); alert("Copied!"); }

function login(){
  const username=document.getElementById('username').value;
  const email=document.getElementById('email').value;
  const password=document.getElementById('password').value;
  if(username && email && password){
    alert("Welcome "+username+"! Scripts unlocked.");
    document.getElementById('loginModal').style.display='none';
    renderScripts();
  } else {
    alert("Please fill all fields.");
  }
}

// Nie pokazujemy skryptów dopóki nie zalogujesz
document.getElementById('scriptsGrid').innerHTML='<p style="text-align:center; color:#777;">Login to unlock scripts!</p>';

</script>

</body>
</html>

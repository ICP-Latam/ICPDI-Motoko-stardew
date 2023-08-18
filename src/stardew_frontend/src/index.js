import { stardew_backend } from "../../declarations/stardew_backend";

const sectionplayers = document.getElementById('players');

function renderplayers(arrayitems){
  let newHTML = '<ul>';
  for (let item of arrayitems) { 
    let id = item['id'];
    let name = item['name'];
    let streams = item['streams'];    
    newHTML += '<li> '+ id +' ' + name + ' ' + streams + '</li>';
  };
  newHTML += '</ul>';
  sectionplayers.innerHTML = newHTML;
};

document.addEventListener('DOMContentLoaded', async (e) => {
  e.preventDefault(); 
  const getplayers = await stardew_backend.getPlayers();
  renderplayers(getplayers)
  return false;
}, false);

document.querySelector("#newplayer").addEventListener("submit", async (e) => {
  e.preventDefault();
  //console.log("newplayer")
  const button = e.target.querySelector("button");
  const name = document.getElementById("name_newplayer").value.toString();
  button.setAttribute("disabled", true);

  const newplayer = await stardew_backend.add_player(name);
  button.removeAttribute("disabled");
  
  //getplayers
  const getplayers = await stardew_backend.getPlayers();
  renderplayers(getplayers)

  return false;
});


document.querySelector("#addstreaming").addEventListener("submit", async (e) => {
  e.preventDefault();
  const button = e.target.querySelector("button");
  const name = document.getElementById("name_addstream").value.toString();
  button.setAttribute("disabled", true);

  const addstream = await stardew_backend.add_streamtoplayer(name);
  button.removeAttribute("disabled");
  
  //getplayers
  const getplayers = await stardew_backend.getPlayers();
  renderplayers(getplayers)
  return false;
});


document.querySelector("#deleteplayer").addEventListener("submit", async (e) => {
  e.preventDefault();
  const button = e.target.querySelector("button");
  const id = document.getElementById("id_delete").value.toString();
  button.setAttribute("disabled", true);

  const addstream = await stardew_backend.deleteplayer_byid(parseInt(id));
  button.removeAttribute("disabled");
  
  //getplayers
  const getplayers = await stardew_backend.getPlayers();
  renderplayers(getplayers)
  return false;
});
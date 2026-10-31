// Title tab of an agent window (TR #2044). The name comes from ?name= and is only ever written
// with textContent / document.title, never parsed as HTML, so a hostile session name cannot inject.
const name = (new URLSearchParams(location.search).get('name') || 'Agent window').slice(0, 200);
document.title = name;
document.getElementById('name').textContent = name;

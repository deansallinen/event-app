document.addEventListener('click', function(event) {
	if (!event.target.matches('.hide')) return;
	event.preventDefault();
	console.log(event.target);
	event.target.style.display = "none";
}, false);

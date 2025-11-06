const profileBtn = document.getElementById('profileBtn');
const profileMenu = document.getElementById('profileMenu');

profileBtn.addEventListener('click', (e) => {
  e.stopPropagation();
  profileMenu.style.display =
    profileMenu.style.display === 'block' ? 'none' : 'block';
});

window.addEventListener('click', (e) => {
  if (!profileMenu.contains(e.target) && e.target !== profileBtn) {
    profileMenu.style.display = 'none';
  }
});

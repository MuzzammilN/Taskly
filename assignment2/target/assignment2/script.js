document.addEventListener("DOMContentLoaded", () => {

    const join = document.getElementById("btn-nav");
    if (join) {
        join.addEventListener("click", () => {
            window.location.href = "login.jsp"; // send user to login instead of signup
        });
    }

    const taskly = document.getElementById("nav_logo");
    if (taskly) {
        taskly.addEventListener("click", () => {
            window.location.href = "index.jsp";
        });
    }

    // disable right-click and certain ctrl+ keys as a deterrent
    document.addEventListener('contextmenu', e => e.preventDefault());
    document.addEventListener('keydown', e => {
        if (e.ctrlKey) {
            const forbidden = ['p','P','s','S','u','U','c','C'];
            if (forbidden.includes(e.key)) {
                e.preventDefault();
            }
        }
    });

});
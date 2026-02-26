document.addEventListener("DOMContentLoaded", () => {

    const join = document.getElementById("btn-nav");
    if (join) {
        join.addEventListener("click", () => {
            window.location.href = "signup.html";
        });
    }

    const taskly = document.getElementById("nav_logo");
    if (taskly) {
        taskly.addEventListener("click", () => {
            window.location.href = "index.html";
        });
    }

});
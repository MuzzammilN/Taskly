Assignment2 Secure Web Information System

This is a practice web application that shows how to build a website where
people need to log in to see private pages. It was made to show how websites
keep user information safe. Here's what it does:

  * **Login System** - Users can log in with a username and password stored in 
    a file called `users.xml`.
  * **Protected Pages** - Some pages are hidden and only logged-in users can see them.
    If you try to go to these pages without logging in, you get sent back to the 
    login page automatically.
  * **No Going Back** - When you log out, clicking the browser's back button won't 
    let you see the private pages again.
  * **Need to Stay Logged In** - When you close your browser, you have to log in again 
    the next time. You don't stay logged in automatically.
  * **Protected Images** - Pictures are stored in a special folder where they can't 
    be seen directly. They only show up when you go through the proper page and 
    you're logged in.
  * **Stop Copying** - The website blocks some annoying things like right-clicking 
    and printing. This isn't real security (it's easy to get around), but it 
    discourages casual copying.
  * **Store Information in Files** - The website stores data like articles and user 
    info in simple text files (XML) instead of a database.
  * **File Format Rules** - There are files (`users.dtd`, `articles.dtd`) that make 
    sure the data is organized correctly.


How to Build and Run
--------------------

This project uses Maven, which is a tool that packages code into a runnable 
application file (like a ZIP). To build it:

    mvn clean package

This creates a `.war` file (kind of like a packaged app) in the `target` folder.
You can put this file on a web server like Tomcat, and the server will run your 
website.


How to Use It
-------------

1. Start the web server and go to the website, like 
   `http://localhost:8080/assignment2/`.
2. Click on the button to log in.
3. Use one of these practice accounts:
   - Username: `alice`, Password: `alice123`
   - Username: `bob`, Password: `bob456`
4. After you log in, you'll see a home page with links to other parts of the site.
5. You can also see a to-do list and a task list to manage your work.
6. Click "Logout" when you're done. If you try to use the back button, you won't 
   be able to see the private pages anymore.


How to Make It Better
---------------------

* **Add More Users** - Edit `users.xml` to add more usernames and passwords.
* **Change What People See** - Replace the articles and data files with your 
  own content.
* **Make It More Secure** - In the future, you could add encryption, stronger 
  passwords, and use a real database instead of files.
* **Use a Real Database** - Instead of storing data in XML files, use a database 
  like MySQL or PostgreSQL.


Important Things to Know
------------------------

- **Blocking right-click and printing doesn't really protect anything** - 
  Someone with computer knowledge can easily get around these blocks. Real 
  security has to be on the server side, not on the website in the browser.
- **Images are hidden in a special folder** - They can't be accessed directly 
  through the URL. They only show up when you're logged in and you go to the 
  proper page. 
- **This is a practice project** - It shows ideas, not a production website. 
  Real websites need much more security features.

This guide should help you understand and run the project. If your teacher 
wants more details about how it works or how safe it is, that should be in 
a separate report document.

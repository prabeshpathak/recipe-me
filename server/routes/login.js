// Import libraries for handling passwords, Google authentication, and JWTs
const bcryptUtil = require('./lib/bcryptUtil');
const googleOAuth = require('./lib/googleOAuth');
const jwt = require('./lib/jwtUtils');

// Import the Mongoose User model for database interaction
const User = require('../models/user'); 

// The root path of this endpoint, which is concatenated to the router path
// In the current version, this is /api/login
const constructPath = require('./lib/constructpath');
const endpointPath = '/login';

// Ensures that passed data is formatted nicely and non-maliciously
function verifyLocal(body, res)
{
    if (!body) {
        res.status(422).json({ error: "No body included in request" });
        return false;
    }

    if (!body.email || typeof(body.email) != "string") {
        res.status(422).json({ error: "No email included in request" });
        return false;
    }
        
    if (!body.password || typeof(body.password) != "string") {
        res.status(422).json({ error: "No password included in request" });
        return false;
    }

    return true;
}

// Function for local login, called after verifyLocal if it succeeds
async function loginLocal(email, password, res) {
    let user = await User.findOne({ email: email.toLowerCase() }).exec();

    // No user is found
    if (user == null) {
        res.status(404).json({ error: "Email and password combination failed to match any existing records" });
        return;
    }

    // Compare the password passed with the one in the database
    bcryptUtil.comparePassword(password, user.password, async function(err, doPasswordsMatch) {
        if (err) {
            res.status(500).json({ error: err });
            return;
        }

        if (!doPasswordsMatch) {
            res.status(404).json({ error: "Email and password combination failed to match any existing records" });
            return;
        }

        // No error, so we can generate and send a JWT
        await jwt.sendLoginBody(user, res);
    });

    return;
}

// Assumed a user might not be logged in to access any of these endpoints
// Loggin in is always an unauthenticated action initially
function safeActions(router) {
    router.post(constructPath(endpointPath, '/'), async function(req, res) { 
        // Verify neccessary information is provided
        let isValid = verifyLocal(req.body, res);
        if (!isValid)
            return;

        // Begin login process
        await loginLocal(req.body.email, req.body.password, res);
    });

    router.post(constructPath(endpointPath, '/google'), async function(req, res) {
        // Verify necessary information is provided
        let { isValid, ticket } = await googleOAuth.verifyGoogle(req.body, res);
        if (!isValid)
            return;

        // Begin login process
        await googleOAuth.loginGoogle(res, ticket);
    });
}


function use(router, authenticatedRouter) {
    // Assign the router to be used
    safeActions(router);
}

// Export the use function, enabling the login endpoint
module.exports = {
    loginLocal: loginLocal,
    verifyLocal: verifyLocal,
    use: use
};
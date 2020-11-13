# Agile and Stability

I don’t think enough attention is given in modern software development to system stability and how the lack of it can negatively impact the agility of a development team.  Forget redundancy, failover, etc. and let’s just talk strait development mistakes and the bugs we create either through bad code, technology choices, design mistakes, etc.  To set the stage for this discussion, see if any of the following sound familiar …

- “Dev environment is down again”
- “Management will not let us make the change right now because they are afraid we will break something”
- “We can’t test right now because ____ broke the build”
- “Do not touch anything, we are getting ready to release”
- “It’s dev so it’s okay”
- “The customer said no to refactoring the code”

If you have been in the industry for a while, this undoubtedly will sound familiar.  You probably have a few other variations of these that come to mind from your past experience.  Often times we as developers don’t fully appreciate the relationship between the agility of a team and the stability of the software they produce.  Switch hats for a minute and think of this from the customers perspective.  We are attempting to show them a product, some software we have created and day in day out all they hear and see are bugs, down environments, performance issues, etc.  Would you buy that product?  If you were purchasing a car and the salesman drove up with the car limping along, sputtering, backfiring, dying in the middle of the road…would you buy the car?  You likely wouldn’t even be willing to take it for a test drive.  This is the reality that our customers see.  Now, let’s put on the hat of a product owner, senior manager, etc.  How do you manage this car limping along, sputtering, backfiring, dying in the middle of the road?  Mind you they need to make the sale otherwise we are all out of a job.  How do you manage the teams of devs working on this car?  Well…this gets really hard, really fast.  The issues that software systems face are many, varied, and everything must align in order to ensure a functioning system.  First, we as devs must face one stubborn immutable fact, any change to a system no matter how awesome, no matter how small, has risk….and every development manager knows it.  So every time we are asking to upgrade a technology, refactor code, use some new tool, etc. we are inevitably asking for permission to take risk.  Many seasoned dev managers will know when / where to take some of these risks.  What happens if the dev team attempt at a new technology, refactor, etc. doesn’t go well?  What have we as devs re-enforced in our managers decision process that will bite us in the future?  Have we reduced the entire teams agility by reducing the likelihood we can get approval to take similar risks in the future?  Let’s review agile principle #5 and #9

- Build projects around motivated individuals.  Give them the environment and support they need, and trust them to get the job done.
- Continuous attention to technical excellence and good design enhances agility.

Think how a dev manager will feel about trusting a dev team if that dev team is breaking things.  Think how a dev manager will feel about allowing a team to improve designs, use new technologies, etc. if that change could take down the dev environment.  What about times when we ship software but don’t include proper unit or integration tests to ensure the features we delivered work?  The reality is we as developers are often our own worst enemy when it comes to embracing agile development.  Nothing in the agile manifesto or modern engineering best practices encourages buggy software.  In fact, quite the contrary, these disciplines focus intensely on producing working software.  Again, let’s review agile principles #1 and #7.

- Our highest priority is to satisfy the customer through early and continuous delivery of valuable software. 
- Working software is the primary measure of progress. 

The difficulty is that ensuring our software works is hard and takes time, discipline, and an intense focus on detail.  Let’s drive this point home a little further with some math.  Assume you are on a development team with 4 other team members (total 5 developers).  There are 5 other teams just like yours all contributing to the same dev environment.  You thinking you are doing great because the last interruption in the dev environment you caused was last month and it was fixed within 2 hours.  Well, guess what…  assuming all other devs are just as awesome as you are the dev environment will be offline more than 10 hours per week with this track record.  Here is the math.

    Let i = # of hours per “MONTH” that I cause a partial or complete outage in the system.  “i” is for interruption.
    Let m = # of dev team members (cross team) contributing to a single system.  “m” is for dev team members
    Let d = # hours per “WEEK” the system is partially or completely down.  “d” is for down.

    Thus,

    d = 40 * (1 - (1 – i / (40 * 52 / 12)) ^ m)

    i = 2 hours of interruption per month caused by single dev
    m = 25 dev team members (5 members per team x 5 teams)
 
    d = 10.07 hours per week of outage

Now, let’s flip this on it’s head and solve for “i” so we can figure out how awesome we really need to be to have a stable environment with say only 4 hours of down per week.

    i = (40 * 52 / 12) * (1 – (1 – d / 40) ^ (1 / m))

    d = 4 hours down per week
    m = 25 dev team members (5 members per team x 5 teams)

    i = 0.73 hours per month of interruption
    
So what should we do in the face of this harsh reality.  I propose some timeless truths.  We MUST test, test, test our software.  Unit and integration tests with preferences for TDD where appropriate really shouldn’t be considered optional.  Improving software design through refactors or upgrading technologies is great and should be done but always understand that you are asking for you manager to take a risk.  Don’t let them and ultimately your customer down.  Don’t teach them that they can’t trust a dev team to make decisions….your teams agility depends on your success.

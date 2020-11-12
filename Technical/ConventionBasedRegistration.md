Convention Based Registration

If we follow the practices outline in my previous post, our registration code will look a lot like this

public void ConfigureServices(IServiceCollection services)
{
container.Register<IMyComponentA, MyComponentA>();
container.Register<IMyComponentB, MyComponentB>();
container.Register<IMyComponentC, MyComponentC>();
…
container.Register<IMyComponentZ, MyComponentZ>();
}

This code, while simple has a few problems.  First, it violates the open-closed principle…it is not closed to modification.  Every time we add a new feature, we must modify this existing method to add more registration.  Attempts at resolving this through enumerable strategies or other design patterns ultimately fail because a component must take the responsibility of providing the master list of all registration components…we have no container to do that for us.  Second, it is an easy step to forget.  Now if we have tests that validate the container or use the container for construction of integration style tests this concern may be somewhat mitigated.  Third and finally, it presents an opportunity for a less seasoned developer (one who may not follow all the guidelines from my previous post) to create some elaborate registration code.  Again, partially mitigated through proper unit / integration tests but still a concern and not foolproof.

The solution to this is known as “convention based registration”.  Thankfully, this isn’t a new concept or without significant support.  For starters, Microsoft uses this approach with MVC.  Have you ever noticed that you never need to register Controllers?  The following code take care of registering all of them as well as any other custom MVC components.
public void ConfigureServices(IServiceCollection services)
{
	container.AddMvc();
}

Conventions work by using reflection to find the defined types within the assembly and register them as appropriate.  Consider the following registration code that finds and registers all interface implementations.
public void ConfigureServices(IServiceCollection services)
{
            Assembly assembly = typeof(Program).Assembly;
            foreach (var type in assembly
                .GetExportedTypes()
                )
            {
                if (!type.IsAbstract && !type.IsGenericTypeDefinition)
                {
                    var interfaces = type.GetInterfaces()
                        .Where(x => x.Assembly == assembly);

                    foreach (var interfaceType in interfaces)
                    {
                        services.AddTransient(interfaceType, type);
                    }
                }
            }
}

I show this code only to open our eyes to the possibilities and also peal back the veil of black box magic that surrounds this concept.  There are also a lot some good community support our registration by convention.  A quick search on the topic found some of these potentially helpful tools as well as plenty of similar posts exposing the benefits of convention based registration.
-	Scrutor 
o	Nuget for adding convention based support to Microsoft.Extensions.DependencyInjections
-	Unity
o	Built in support for conventions.
A few small technical details to point out with assembly loading and reflection.  Assemblies are only loaded into an app domain upon first request.  Thus, if we simply query for all loaded assemblies (i.e. AppDomain.CurrentDomain.GetAssemblies()) we will not get a complete list of all assemblies in the project especially if this code is executed early on in the process lifecycle such as startup with registration code.  That is why you will see code which ultimately invokes or looks like typeof(MyClassInAssemblyA).Assembly in convention based registration.  There are alternatives to this but most end in equally if not worse couplings or complexities.  The other technical note with this is that convention based registration with code like this has the side effect of forcing all scanned / referenced assemblies to load upon startup.  This can lead to slightly longer startup times but to be honest, only in the most extreme of cases is this ever an issue.  This may actually be a good thing as it saves the hit from the first request.  In practice, I’ve had systems with literally 100’s of assemblies and all of them were loaded through registration scanning within a matter of seconds.

A final note on this about governance.  I mentioned in my previous post that these disciplines can help lead to governance and they absolutely can.  So in this post we discussed using convention based registration to improve our code.  As we work in enterprise systems which undoubtedly have a shape and structure that has been designed with intent, we want to ensure that developers follow that design and conform to the structure of the system: things such as what types of components to create, naming conventions, etc.  Keeping this all in mind and consider a system in which all components were registered by conventions.  Consider a system where manual registration wasn’t allowed or possible for that matter.  Consider conventions that were very precise in the types of components they would register and would let those that didn’t conform to those standards be dropped on the floor.  Consider allowing for unbounded extension to known abstractions or possibly even unbounded interface definitions and implementations as the example above would support.  Assume only certain base classes were registered but others were ignored.  All that needs to be done to accomplish all of this with convention based registration is pull the registration conventions out of the project and into a managed nuget.  Depending on how far you go with other framework pieces, the entire application startup can be pulled out of the code base an into a nuget.  I had the privilege to work in such an enterprise framework for several years and the amount of problems this solved was absolutely amazing.  For years we suffered from developers accidentally burying complexity in registration code and making bad design choices with constructor injected dependencies.  Centralizing and managing the registration code was an amazing tool to help stop those bad practices.  Now, this is far from the final answer for governing large code bases but is definitely something to strongly consider when you want to help guide conformity to a design.  This approach though assumes you understand your architecture and the shape of the business problems that you plan to solve.  If you are unsure of either, governance like this may be a bridge too far.  Pulling the registration code out into a nuget for your team to share may still be useful though so definitely keep this in your back pocket.  Either way, understand that what we have with convention based registration is a very powerful too in helping guide developers in the way in which they write code.

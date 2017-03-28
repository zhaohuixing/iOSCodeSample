//
//  SBBComponentManager.h
//
//
//

#import <Foundation/Foundation.h>

#define XZBaseComponent(componentClass) ((id<componentClass ## Protocol>)[XZBaseComponentManager component:[componentClass class]])

#define SBBTestComponent(testClass, componentClass) ((testClass *)[XZBaseComponentManager component:[componentClass class]])

/*!
 * This class provides a central point for managing singleton components, to simplify use of dependency injection
 * in the default case, when needing runtime selection between two or more implementations, and mocking for testing.
 *
 * In general, you should access all such components through this class, either via the component: class method
 * or one of the convenience macros SBBComponent(class) or SBBTestComponent(testClass, class).
 */
@interface XZBaseComponentManager : NSObject

/*!
 *  Register a specific component instance to be returned by requests for components registered to a given class.
 *
 *  This method can be used both for registering mock components for testing purposes, and for handling the
 *  case where you need to choose one of two or more alternative implementations at runtime based on criteria
 *  not available at compile time.
 *
 *  @param componentInstance The component instance to register for the given componentClass.
 *  @param componentClass    The class for which to register the given component.
 *
 *  @return The component instance, if any, previously registered for the given componentClass.
 */
+ (id)registerComponent:(id)componentInstance forClass:(Class)componentClass;

/*!
 *  Return the registered instance of the component for the given class.
 *
 *  If no instance is registered, and componentClass implements the SBBComponent protocol, this method will
 *  call the class's defaultComponent: class method and register the returned value as the instance for the class.
 *
 *  @param componentClass The class for which to get (or instantiate and register) the registered component instance.
 *
 *  @return The registered instance for the given componentClass.
 */
+ (id)component:(Class)componentClass;

/*!
 Clear all registered components and start fresh. Used for unit testing.
 */
+ (void)reset;

@end

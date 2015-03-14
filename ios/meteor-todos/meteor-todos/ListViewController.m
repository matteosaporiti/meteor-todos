#import "ListViewController.h"
#import "MeteorClient.h"

@interface ListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (copy, nonatomic) NSString *listName;

@end

@implementation ListViewController

- (NSArray *)computedList {
    
    M13MutableOrderedDictionary *things = self.meteor.collections[self.listName];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"numCreatedAt" ascending:NO];
    NSArray *mytest = [things.allObjects sortedArrayUsingDescriptors:@[sort]];
    
    return mytest;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil meteor:(MeteorClient *)meteor {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.meteor = meteor;
        self.listName = @"tasks";
    }
    return self;

}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationItem.title = @"My Tasks";
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    
    self.navigationItem.rightBarButtonItem = logoutButton;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUpdate:)
                                                 name:@"added"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUpdate:)
                                                 name:@"removed"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUpdate:)
                                                 name:@"changed"
                                               object:nil];
    
}

- (void)didReceiveUpdate:(NSNotification *)notification {
    
    [self.tableview reloadData];

}

- (void)logout {

    [self.meteor logout];
    [self.navigationController popToRootViewControllerAnimated:YES];

}

#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.computedList count];

}

static NSDictionary *selectedList;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"list";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }

    NSDictionary *list = self.computedList[indexPath.row];
    selectedList = list;
    cell.textLabel.text = list[@"text"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *list = self.computedList[indexPath.row];
    
    [self.meteor callMethodName:@"deleteTask" parameters:@[list[@"_id"]] responseCallback:^(NSDictionary *response, NSError *error) {
        NSString *message = response[@"result"];
        [[[UIAlertView alloc] initWithTitle:@"Meteor Todos" message:message delegate:nil cancelButtonTitle:@"Great" otherButtonTitles:nil] show];
    }];
    
}

#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end

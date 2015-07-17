//fork availible

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"
#import "MessageDetailViewController.h"
#import "ParseExampleAppDelegate.h"
@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *chats;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatCell" bundle:nil] forCellReuseIdentifier:@"ChatCell"];

    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [self onTimer];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    cell.chatLabel.text = self.chats[indexPath.row];
    return cell;
}

- (IBAction)onSend:(id)sender {
    NSLog(_textField.text);
  PFObject *replyMessage = [PFObject objectWithClassName:@"CustomMessage"];
 replyMessage[@"title"]= _textField.text;
    replyMessage[@"toUser"]=self.parseMessage[@"user"]; //Sets the message the person sends to be == the person who sent it
  replyMessage[@"user"]= @"asdfasfd";
    replyMessage[@"note"]= @"constant";
    replyMessage[@"explanation"]=@"none";
    //Sets the message the person sends to be == the person who sent it
    replyMessage[@"category"]=@"asfd";


    [replyMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //show alert
            UIAlertView *sucess = [[UIAlertView alloc]
                                   initWithTitle: @"Reply Sent"
                                   message: @"Your reply has been sent."
                                   delegate:self
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:NULL];
            [sucess show];
        } else {
            // There was a problem, check error.description
            UIAlertView *error = [[UIAlertView alloc]
                                  initWithTitle: @"Error Occured"
                                  message: @"An error occured. Try again later or email turms@yqpc.net"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:NULL];
            [error show];
        }
    }];
}

- (void)onTimer {

    ParseExampleAppDelegate *delegate = [[UIApplication sharedApplication] delegate];

    
    PFQuery *query = [PFQuery queryWithClassName:@"CustomMessage"];

    [query whereKey:@"toUser" equalTo:delegate.applicationUser];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %ld scores.", objects.count);
            //
            //self.chats = [NSMutableArray arrayWithObjects:objects, nil];

            for (PFObject *object in objects) {
                
                if ([object objectForKey:@"text"] != nil) {
                    [self.chats addObject:object[@"text"]];
                }
            }

            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end

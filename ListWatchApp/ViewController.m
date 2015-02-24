#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *tableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *getShoppingList = @"https://www.kroger.com/api/shoppinglist/list/0d0488c0-01b2-1f17-a4bb-d4cfb79e3c80";
    NSURL *url = [NSURL URLWithString:getShoppingList];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData                                                       timeoutInterval:10];
    NSString *cookieValues = @"aid=0284A970D3D079AC8F4E19E33AE7FB51D0AE54C49581778FB9E378E8F4C7B6E228706B41633FC7E1AB37A373587D0B22; sid=adc69575-061b-492f-87b3-614a1ae5241a";
    [request setValue:cookieValues forHTTPHeaderField:@"Cookie"];
    
    [request setHTTPMethod: @"GET"];
    
    NSMutableArray *mutableTable = [[NSMutableArray alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError){
                               NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                          options:kNilOptions
                                                                                            error:nil];
                               NSArray *items = [dictionary objectForKey:@"items"];
                               for (NSDictionary *item in items)
                               {
                                   NSString *itemName = [item objectForKey:@"itemName"];
                                   NSLog(@"Item: %@", itemName);
                                   [mutableTable addObject:itemName];
                               }
                           }
     ];
    
    tableData = [NSArray arrayWithArray:mutableTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"TableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"batman.png"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

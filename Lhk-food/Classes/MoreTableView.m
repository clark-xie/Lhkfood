//
//  MoreTableView.m
//  MapViewDemo
//
//  Created by huwei on 12/6/12.
//
//

#import "MoreTableView.h"

@interface MoreTableView ()

@end

@implementation MoreTableView
@synthesize tableView = _tableView;
@synthesize headViewArray;
@synthesize category=_category;
@synthesize kdelegate,mdelegate;
@synthesize isKorM;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isKorM = @"k";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked:)];
    [barButton setTitle:@"返回"];
    [self.navigationItem setLeftBarButtonItem:barButton];
    [self.navigationItem setTitle: @"更多分类"];
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initcates];
    [self loadModel];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)backButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)initcates
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Category" withExtension:@"plist"];
    self.category = [NSArray arrayWithContentsOfURL:url];
}
- (void)loadModel{
    _currentRow = -1;
    headViewArray = [[NSMutableArray alloc] init];
    for(int i = 0;i< self.category.count ;i++)
	{
		HeadView* headview = [[HeadView alloc] init];
        headview.delegate = self;
		headview.section = i;
        NSString *title = [[self.category objectAtIndex:i] objectForKey:@"name"];
        [headview.backBtn setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
		[self.headViewArray addObject:headview];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _tableView= nil;
}

#pragma mark - TableViewdelegate&&TableViewdataSource

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HeadView* headView = [self.headViewArray objectAtIndex:indexPath.section];
    
    return headView.open?45:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self.headViewArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HeadView* headView = [self.headViewArray objectAtIndex:section];
    NSInteger n = [[[self.category objectAtIndex:section] objectForKey:@"list"] count];
    return headView.open?n:0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.headViewArray count];
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        UIButton* backBtn=  [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
        backBtn.tag = 20000;
        [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_on"] forState:UIControlStateHighlighted];
        backBtn.userInteractionEnabled = NO;
        [cell.contentView addSubview:backBtn];
        
        
        UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 1)];
        line.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:line];
        
    }
    UIButton* backBtn = (UIButton*)[cell.contentView viewWithTag:20000];
    HeadView* view = [self.headViewArray objectAtIndex:indexPath.section];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_2_nomal"] forState:UIControlStateNormal];
    
    if (view.open) {
        if (indexPath.row == _currentRow) {
            [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_nomal"] forState:UIControlStateNormal];
        }
    }
    NSArray *subtitle =  [[self.category objectAtIndex:indexPath.section] objectForKey:@"list"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[subtitle objectAtIndex:indexPath.row] objectForKey:@"name"]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentRow = indexPath.row;
    NSArray *subtitle =  [[self.category objectAtIndex:indexPath.section] objectForKey:@"list"];
    NSString *name = nil;
    NSString *code = nil;
    name =[[subtitle objectAtIndex:indexPath.row] objectForKey:@"name"];
    code =[[subtitle objectAtIndex:indexPath.row] objectForKey:@"code"];
    if ([self.isKorM isEqualToString:@"k"]) {
        
        [self.kdelegate passValue:name classCode:name];
    }
    else{
        [self.mdelegate passValue:name classCode:name];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [_tableView reloadData];
}


#pragma mark - HeadViewdelegate
-(void)selectedWith:(HeadView *)view{
    _currentRow = -1;
    if (view.open) {
        for(int i = 0;i<[headViewArray count];i++)
        {
            HeadView *head = [headViewArray objectAtIndex:i];
            head.open = NO;
            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
        }
        [_tableView reloadData];
        return;
    }
    _currentSection = view.section;
    [self reset];
    
}

//界面重置
- (void)reset
{
    for(int i = 0;i<[headViewArray count];i++)
    {
        HeadView *head = [headViewArray objectAtIndex:i];
        
        if(head.section == _currentSection)
        {
            head.open = YES;
            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_nomal"] forState:UIControlStateNormal];
            
        }else {
            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
            
            head.open = NO;
        }
        
    }
    [_tableView reloadData];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

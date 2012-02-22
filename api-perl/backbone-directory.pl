#!/usr/bin/env perl
use Mojolicious::Lite;
use Mojolicious::Static;
use DBIx::Simple;
use Try::Tiny;

# replace these with yours 

my $dbhost = 'database-hostname';
my $dbname = 'directory';
my $user   = 'user';
my $pass   = 'password';

push @{app->static->paths}, app->home->rel_dir('../web');

my $db = DBIx::Simple->connect("dbi:mysql:database=$dbname;host=$dbhost",$user,$pass);
$db->lc_columns = 0;

helper error => sub {
  my $self = shift;
  
  if(defined $db)
  {
    return {"error" => {"text" => $db->error }};
  }else
  {
    return {"error" => {"text" => "unable to connect to database" }};
  }
};

helper findByName => sub {
    my ($self, $query ) = @_;
    return try{ $db->query("SELECT id, firstName, lastName, title
			  FROM employee WHERE UPPER(CONCAT(firstName, ' ', lastName))
			  LIKE ? ORDER BY lastName","%$query%")->hashes } catch { $self->error };
};

helper getEmployee => sub {
    my ($self, $query ) = @_;
    return try{ $db->query("select e.id, e.firstName, e.lastName, e.title, e.officePhone,
			      e.cellPhone, e.email, e.managerId, e.twitterId,
			      m.firstName managerFirstName, m.lastName managerLastName " .
			     "from employee e left join employee m on e.managerId = m.id " .
			     "where e.id = ? ",$query)->hashes } catch { $self->error };  
};

helper getEmployees => sub {
    my $self = shift;
    return try {db->query("select id, firstName, lastName, title FROM employee ORDER BY lastName, firstName")->hashes; }
           catch { $self->error };
};

helper getReports => sub {
    my ($self, $query ) = @_;
   return try { \@{$db->query("select e.id, e.firstName, e.lastName, e.title " .
			"from employee e left join employee r on r.managerId = e.id " .
			"where e.managerId = ? group by e.id order by e.lastName, e.firstName",$query)->hashes} }
                        catch { $self->error };
};

get '/' => sub {
  my $self = shift;
  $self->render_static('index.html');
};

get '/api/employees/search/:query' => sub {
  my $self = shift;
  $self->render_json( $self->findByName($self->param('query')) );
};

get '/api/employees/:query' => sub {
  my $self = shift;
  $self->render_json( $self->getEmployee($self->param('query')) );
};

get '/api/employees' => sub {
  my $self = shift;
  $self->render_json( $self->getEmployees() );
};

get '/api/employees/:query/reports' => sub {
  my $self = shift;
  $self->render_json( $self->getReports($self->param('query')) );
};

app->start;


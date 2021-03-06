#!/usr/bin/perl

=head1 NAME
random_addresses.pl – generate random addresses

=head1 USAGE
Run like C<perl script/random_addresses.pl | perl script/import_csv. pl>

=cut

my @names = qw(Foo Bar Baz Test Jonathan Rockway Person Another A);
my @locations = qw(Home Work Mobile Fax Test);
my @streets = qw(Green Oak Elm 60th Fake State Halsted);

for(1..200){
	my $first = $names[rand @names];
	my $last = $names[rand @names];
	my $where = $locations[rand @locations];
	my $number = int rand 9900 + 100; # 3-digit street number 
	my $street = $streets[rand @streets];
	my $address = "$number $street St.";
	my $phone = join '-', (int rand 800 + 100, int rand 899 + 100, int rand 8999 + 1000);
	my $email = "$first.$last\@$where.example.com";
	print "$first,$last,$where,$address,$phone,$email\n";
}
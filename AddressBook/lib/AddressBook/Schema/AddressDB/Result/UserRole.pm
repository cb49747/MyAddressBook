use utf8;
package AddressBook::Schema::AddressDB::Result::UserRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

AddressBook::Schema::AddressDB::Result::UserRole

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<user_role>

=cut

__PACKAGE__->table("user_role");

=head1 ACCESSORS

=head2 user

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 role

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "role",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user>

=item * L</role>

=back

=cut

__PACKAGE__->set_primary_key("user", "role");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<AddressBook::Schema::AddressDB::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "AddressBook::Schema::AddressDB::Result::Role",
  { id => "role" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 user

Type: belongs_to

Related object: L<AddressBook::Schema::AddressDB::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "AddressBook::Schema::AddressDB::Result::User",
  { id => "user" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-02-05 09:48:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TBukrcCo7idNFpBOrm0Ljw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;

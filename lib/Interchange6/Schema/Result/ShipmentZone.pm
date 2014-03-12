use utf8;
package Interchange6::Schema::Result::ShipmentZone;

=head1 NAME

Interchange6::Schema::Result::ShipmentZone;

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<shipment_zones>

=cut

__PACKAGE__->table("shipment_zones");

=head1 ACCESSORS

=head2 shipment_zones_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 country_iso_code

  data_type: 'char'
  is_foreign_key: 1
  is_nullable: 1

=head2 state_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 shipment_methods_id

  type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 postal_range_start

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 postal_range_end

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 zone 

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "shipment_zones_id",
  {
    data_type => "integer",
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "country_iso_code",
  { data_type => "char", is_foreign_key => 1, is_nullable => 1 },
  "state_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "shipment_methods_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "postal_range_start",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "postal_range_end",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "zone",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
  "last_modified",
  { data_type => "datetime", set_on_create => 1, set_on_update => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</shipment_zones_id>

=back

=cut

__PACKAGE__->set_primary_key("shipment_zones_id");

=head1 RELATIONS

=head2 Country

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Country>

=cut

__PACKAGE__->belongs_to(
  "Country",
  "Interchange6::Schema::Result::Country",
  { country_iso_code => "country_iso_code" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 State

Type: belongs_to

Related object: L<Interchange6::Schema::Result::State>

=cut

__PACKAGE__->belongs_to(
  "State",
  "Interchange6::Schema::Result::State",
  { state_id => "state_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 ShipmentMethod

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ShipmentMethod>

=cut

__PACKAGE__->belongs_to(
  "ShipmentMethod",
  "Interchange6::Schema::Result::ShipmentMethod",
  { shipment_methods_id => "shipment_methods_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


1;

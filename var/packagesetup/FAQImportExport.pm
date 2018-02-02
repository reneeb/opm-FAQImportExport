# --
# FAQImportExport.pm - code run during package de-/installation
# Copyright (C) 2006-2015 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Torsten(dot)Thau(at)cape-it.de
# * Mario(dot)Illinger(at)cape(dash)it(dot)de
# * Anna(dot)Litvinova(at)cape(dash)it(dot)de
# --
# $Id: FAQImportExport.pm,v 1.11 2015/09/11 08:54:39 tlange Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package var::packagesetup::FAQImportExport;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::ImportExport',
    'Kernel::System::DynamicField',
    'Kernel::System::FAQ',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Valid',
    'Kernel::Config'
);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

=head1 NAME

code to excecute during package installation

=head1 SYNOPSIS

All functions

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}


=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    $Self->_CreateMappings();

    return 1;
}

=item CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    $Self->_CreateMappings();

    return 1;
}

=item CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    $Self->_RemoveRelatedMappings();

    return 1;
}

sub _RemoveRelatedMappings () {

    my ( $Self, %Param ) = @_;

    my $TemplateList;
    my @TemplateObjects = ( 'FAQ' );
    my @TemplateObjectsSum;
    foreach my $TemplateObject (@TemplateObjects) {
        $TemplateList = $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateList(
            Object => $TemplateObject,
            Format => 'CSV',
            UserID => 1,
        );
        @TemplateObjectsSum = ( @TemplateObjectsSum, @{$TemplateList} );
    }

    # delete the templates
    if ( ref($TemplateList) eq 'ARRAY' && @{$TemplateList} ) {
        $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateDelete(
            TemplateID => \@TemplateObjectsSum,
            UserID     => 1,
        );
    }

    return 1;
}

sub _CreateMappings () {
    my ( $Self, %Param ) = @_;

    my $ImportExportMappingHash = undef;

    $ImportExportMappingHash->{FAQ} = [
        'Number', 'Title', 'Category',

        # Not required yet, because of not implemented part
        # for update existing category in function _CheckCategory
        #        'CategoryID',
        'State', 'Language', 'Approved', 'Keywords',
        'Field1', 'Field2', 'Field3', 'Field4', 'Field5', 'Field6'
    ];

    for my $ObjectMappingKey ( keys %{$ImportExportMappingHash} ) {

        my $TemplateName = $ObjectMappingKey . " (auto-created map)";
        my %TemplateList = ();

        # get config option
        my $ForceCSVMappingConfiguration = $Kernel::OM->Get('Kernel::Config')->Get(
            'ImportExport::FAQImportExport::ForceCSVMappingRecreation'
        ) || '0';

        # get list of all templates
        my $TemplateListRef = $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateList(
            Object => $ObjectMappingKey,
            Format => 'CSV',
            UserID => 1,
        );

        # get data for each template and build hash with key = template name; value = template ID
        if ( $TemplateListRef && ref($TemplateListRef) eq 'ARRAY' ) {
            for my $CurrTemplateID ( @{$TemplateListRef} ) {
                my $TemplateDataRef = $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateGet(
                    TemplateID => $CurrTemplateID,
                    UserID     => 1,
                );
                if (
                    $TemplateDataRef
                    && ref($TemplateDataRef) eq 'HASH'
                    && $TemplateDataRef->{Object}
                    && $TemplateDataRef->{Name}
                    )
                {
                    $TemplateList{ $TemplateDataRef->{Object} . '::' . $TemplateDataRef->{Name} }
                        = $CurrTemplateID;
                }
            }
        }

        my $TemplateID;

        # check if template already exists...
        if ( $TemplateList{ $ObjectMappingKey . '::' . $TemplateName } ) {
            if ($ForceCSVMappingConfiguration) {

                # delete old template
                $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateDelete(
                    TemplateID => $TemplateList{ $ObjectMappingKey . '::' . $TemplateName },
                    UserID     => 1,
                );
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'notice',
                    Message  => "CSV mapping deleted for re-creation <"
                        . $TemplateName
                        . ">.",
                );

                # create new template
                $TemplateID = $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateAdd(
                    Object  => $ObjectMappingKey,
                    Format  => 'CSV',
                    Name    => $TemplateName,
                    Comment => "Automatically created during FAQImportExport installation",
                    ValidID => 1,
                    UserID  => 1,
                );
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "CSV mapping already exists and not re-created <"
                        . $TemplateName
                        . ">.",
                );
                return 1;
            }
        }
        else {

            # create new template
            $TemplateID = $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateAdd(
                Object  => $ObjectMappingKey,
                Format  => 'CSV',
                Name    => $TemplateName,
                Comment => "Automatically created during FAQImportExport installation",
                ValidID => 1,
                UserID  => 1,
            );
        }

        if ( !$TemplateID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not add mapping for object $ObjectMappingKey",
            );
            next;
        }

        my $FAQMappingData = {
            SourceFAQData => {
                FormatData => {
                    ColumnSeparator => 'Semicolon',
                    Charset         => 'UTF-8',
                    IncludeColumnHeaders => '1',
                },
                FAQDataGet => {
                    TemplateID => $TemplateID,
                    UserID     => 1,
                },
            },
        };

        # get object attributes
        my $ObjectAttributeList = $Kernel::OM->Get('Kernel::System::ImportExport')->ObjectAttributesGet(
            TemplateID => $FAQMappingData->{SourceFAQData}->{FAQDataGet}
                ->{TemplateID},
            UserID => 1,
        );

        my $AttributeValues;

        for my $Default ( @{$ObjectAttributeList} ) {
            $AttributeValues->{ $Default->{Key} } =
                $Default->{Input}->{ValueDefault};
        }

        $FAQMappingData->{SourceFAQData}->{ObjectData} = $AttributeValues;

        my $DefaultNumberOfAssignableFAQs =
            $FAQMappingData->{SourceFAQData}->{ObjectData}
            ->{NumberOfAssignableFAQs};

        my $i = 0;
        my @MappingObjData;
        foreach my $Key ( @{ $ImportExportMappingHash->{$ObjectMappingKey} } ) {

            my %MappingObjectDataHash;
            $MappingObjectDataHash{Key} =
                $ImportExportMappingHash->{$ObjectMappingKey}->[$i];
            if ( $i == 0 ) {
                $MappingObjectDataHash{Identifier} = 1;
            }
            if ( $Key eq 'Valid' && !$AttributeValues->{DefaultValid} ) {
                next;
            }

            if ( $Key eq 'AssignedFAQ' ) {
                for (
                    my $Count = 0;
                    $Count < $DefaultNumberOfAssignableFAQs;
                    $Count++
                    )
                {
                    my %MappingObjectDataHashLocal = ();
                    $MappingObjectDataHashLocal{Key} =
                        'AssignedFAQ' . sprintf( '%03s', $Count );
                    push( @MappingObjData, \%MappingObjectDataHashLocal );
                }
            }
            else {
                push( @MappingObjData, \%MappingObjectDataHash );
            }

            $i++;
        }

        $FAQMappingData->{SourceFAQData}->{MappingObjectData} =
            \@MappingObjData;

        if (
            !$FAQMappingData
            || ref $FAQMappingData ne 'HASH'
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "No valid mapping list found for template id $TemplateID",
            );
            return;

        }

        # set the object data
        if (
            $FAQMappingData->{SourceFAQData}->{ObjectData}
            && ref $FAQMappingData->{SourceFAQData}->{ObjectData} eq 'HASH'
            && $FAQMappingData->{SourceFAQData}->{FAQDataGet}
            ->{TemplateID}
            )
        {

            # save object data
            $Kernel::OM->Get('Kernel::System::ImportExport')->ObjectDataSave(
                TemplateID =>
                    $FAQMappingData->{SourceFAQData}->{FAQDataGet}
                    ->{TemplateID},
                ObjectData =>
                    $FAQMappingData->{SourceFAQData}->{ObjectData},
                UserID => 1,
            );
        }

        # set the format data
        if (
            $FAQMappingData->{SourceFAQData}->{FormatData}
            && ref $FAQMappingData->{SourceFAQData}->{FormatData} eq 'HASH'
            && $FAQMappingData->{SourceFAQData}->{FAQDataGet}
            ->{TemplateID}
            )
        {

            # save format data
            $Kernel::OM->Get('Kernel::System::ImportExport')->FormatDataSave(
                TemplateID =>
                    $FAQMappingData->{SourceFAQData}->{FAQDataGet}
                    ->{TemplateID},
                FormatData =>
                    $FAQMappingData->{SourceFAQData}->{FormatData},
                UserID => 1,
            );
        }

        # set the mapping object data
        if (
            $FAQMappingData->{SourceFAQData}->{ObjectData}

            #&& ref $FAQMappingData->{MappingObjectData} eq 'ARRAY'
            && $FAQMappingData->{SourceFAQData}->{FAQDataGet}
            ->{TemplateID}
            )
        {

            # delete all existing mapping data
            $Kernel::OM->Get('Kernel::System::ImportExport')->MappingDelete(
                TemplateID =>
                    $FAQMappingData->{SourceFAQData}->{FAQDataGet}
                    ->{TemplateID},
                UserID => 1,
            );

            # add the mapping object rows

            for my $MappingObjectData (
                @{ $FAQMappingData->{SourceFAQData}->{MappingObjectData} }
                )
            {

                # add a new mapping row
                my $MappingID = $Kernel::OM->Get('Kernel::System::ImportExport')->MappingAdd(
                    TemplateID =>
                        $FAQMappingData->{SourceFAQData}->{FAQDataGet}
                        ->{TemplateID},
                    UserID => 1,
                );

                # add the mapping object data
                $Kernel::OM->Get('Kernel::System::ImportExport')->MappingObjectDataSave(
                    MappingID         => $MappingID,
                    MappingObjectData => $MappingObjectData,
                    UserID            => 1,
                );
            }
        }
    }

    return 1;

}
1;


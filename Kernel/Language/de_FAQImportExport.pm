# --
# Kernel/Language/de_FAQImportExport - provides german language
# Copyright (C) 2006-2015 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# translation for FAQImportExport module
# --
# $Id: de_FAQImportExport.pm,v 1.7 2015/11/17 11:36:43 tlange Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::de_FAQImportExport;

use strict;
use warnings;
use utf8;

sub Data
{
    my $Self = shift;
    my $Lang = $Self->{Translation};
    return if ref $Lang ne 'HASH';

    # $$START$$
    # translations missing in ImportExport...
    $Lang->{'Column Seperator'}           = 'Spaltentrenner';
    $Lang->{'Charset'}                    = 'Zeichensatz';
    $Lang->{'Restrict export per search'} = 'Export mittels Suche einschränken';
    $Lang->{'Validity'}                   = 'Gültigkeit';

    #    $Lang->{'Export with labels'}         = 'Mit Beschriftung exportieren';
    $Lang->{'Default Category (if empty/invalid)'}
        = 'Standardkategorie (wenn leer/ungültig)';
    $Lang->{'Default State (if empty/invalid)'}
        = 'Standardstatus (wenn leer/ungültig)';
    $Lang->{'Default group for new category'} = 'Standardgruppe für neue Kategorie';
    $Lang->{'Default Language (if empty/invalid)'}
        = 'Standardsprache (wenn leer/ungültig)';
    $Lang->{'Approved'} = 'Freigegeben';
    $Lang->{'Object backend module registration for the import/export module.'} =
        'Objekt-Backend Modul Registration des Import/Export Moduls.';

    #    $Lang->{''}         = '';
    return 0;

    # $$STOP$$
}

1;

<?php

if ( isset( $_GET['emails'] ) ) {
    $subject = 'Test subject';
    $message = 'Test message';
    $delimiter = isset( $_GET['delimiter'] ) ? $_GET['delimiter'] : ',' ;
    $emails = array_slice( explode( $delimiter, $_GET['emails'] ), 0, 3 );
    $from_email = isset( $_GET['from_email'] ) ? $_GET['from_email'] : NULL ;
    $from_name = isset( $_GET['from_name'] ) ? $_GET['from_name'] : NULL ;
    $from = NULL;
    if ( ! empty( $from_email ) ) {
        $from = sprintf( "From: %s\r\n", $from_email );
        if ( ! empty( $from_name ) ) {
            $from = sprintf( "From: %s <%s>\r\n", $from_name, $from_email );
        }
    }
    foreach ( $emails as $email ) {
        echo sprintf( 'Email: %s <br/>', $email );
        echo sprintf( 'Subject: %s <br/>', $subject );
        echo sprintf( 'Message: %s <br/>', $message );
        echo sprintf( 'Headers: %s <br/>', htmlentities( $from ) );
        echo '<br/>';
        if ( ! empty( $from ) ) {
            mail( $email, $subject, $message, $from );
        } else {
            mail( $email, $subject, $message );
        }
    }
}

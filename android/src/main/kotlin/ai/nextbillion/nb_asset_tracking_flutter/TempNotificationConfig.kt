package ai.nextbillion.nb_asset_tracking_flutter

import ai.nextbillion.assettracking.entity.LowBatteryNotificationConfig
import android.app.Notification
import android.app.PendingIntent
import android.graphics.Bitmap
import android.os.Parcelable
import android.widget.RemoteViews

data class TempNotificationConfig(

    var serviceId: Int = (1..Int.MAX_VALUE).random(),

    val channelId: String = "NextBillion.AI",

    /**
     * The channel name of the notification
     */
    val channelName: String = "NextBillion.AI",

    /**
     * The title of the notification view
     */
    val title: String?,

    /**
     * The content of the notification view when tracking start
     */
    val content: String?,

    /**
     *  The small icon image of the notification view
     */
    val smallIcon: String?,

    /**
     * The large notification icon resource id
     */
    val largeIcon: String?,

    /**
     * The big icon image of the notification view
     */
    val largeIconBitmap: Bitmap? = null,


    /**
     * Custom layout for the remote view
     */
    val remoteViews: RemoteViews? = null,

    /**
     * Customize the large layout for the remote view
     */
    val bigRemoteViews: RemoteViews? = null,

    /**
     *  A {@link PendingIntent} instance set by user, When this parameter is set, the click notification title bar will take effect and jump to the target Activity
     */
    @Transient
    var pendingIntent: PendingIntent? = null,

    /**
     * A {@link Notification} instance set by user
     *  @note The configuration mentioned above will not take effect when using the property of the Notification passed by the user.
     */
    @Transient
    var notification: Notification? = null,

    /**
     * The NotificationChannel set by user
     */
    @Transient
    var notificationChannel: Parcelable? = null,

    /**
     * A flag to determine whether display the low battery notification
     */
    val showLowBatteryNotification: Boolean = true,

    /**
     * Customize the low battery notification
     */
    val lowBatteryNotification: LowBatteryNotificationConfig = LowBatteryNotificationConfig(),

    /**
     * A flag to determine whether display the asset id taken notification
     */
    val showAssetIdTakenNotification: Boolean = true,

    /**
     * The content of the notification view when tracking stop
     */
    val contentAssetDisable: String?,

    /**
     * The content of the notification view when assetId is used by another device
     */
    val assetIdTakenContent: String?

)
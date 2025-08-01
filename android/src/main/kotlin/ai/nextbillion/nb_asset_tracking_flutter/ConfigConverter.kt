package ai.nextbillion.nb_asset_tracking_flutter

import ai.nextbillion.assettracking.entity.DataTrackingConfig
import ai.nextbillion.assettracking.entity.DefaultConfig
import ai.nextbillion.assettracking.entity.LocationConfig
import ai.nextbillion.assettracking.entity.LowBatteryNotificationConfig
import ai.nextbillion.assettracking.entity.NotificationConfig
import ai.nextbillion.assettracking.location.engine.DesiredAccuracy
import ai.nextbillion.assettracking.location.engine.TrackingMode
import ai.nextbillion.network.AssetProfile
import ai.nextbillion.network.trip.TripProfile
import ai.nextbillion.network.trip.TripUpdateProfile
import ai.nextbillion.network.trip.entity.Trip
import ai.nextbillion.network.trip.entity.TripSummary
import android.content.Context
import android.location.Location
import com.google.gson.Gson
import org.json.JSONObject

object ConfigConverter {

    fun notificationConfigFromJson(jsonString: String): TempNotificationConfig {
        val gson = Gson()
        return gson.fromJson(jsonString, TempNotificationConfig::class.java)
    }

    fun defaultConfigFromJson(jsonString: String): DefaultConfig {
        val gson = Gson()
        return gson.fromJson(jsonString, DefaultConfig::class.java)
    }
    fun notificationConfigToJson(config: NotificationConfig): String {
        val gson = Gson()
        return gson.toJson(config, NotificationConfig::class.java)
    }

    /**
     * Converts TempNotificationConfig to NotificationConfig
     * Uses getDrawableResourceId to convert string icon names to resource IDs
     */
    fun convertTempToNotificationConfig(tempConfig: TempNotificationConfig, context: Context): NotificationConfig {
        return NotificationConfig(
            serviceId = tempConfig.serviceId,
            channelId = tempConfig.channelId,
            channelName = tempConfig.channelName,
            title = tempConfig.title ?: "",
            content = tempConfig.content ?: "",
            smallIcon = getDrawableResourceId(context, tempConfig.smallIcon ?: ""),
            largeIcon = getDrawableResourceId(context, tempConfig.largeIcon ?: ""),
            showLowBatteryNotification = tempConfig.showLowBatteryNotification,
            lowBatteryNotification = tempConfig.lowBatteryNotification,
            showAssetIdTakenNotification = tempConfig.showAssetIdTakenNotification,
            contentAssetDisable = tempConfig.contentAssetDisable ?: "",
            assetIdTakenContent = tempConfig.assetIdTakenContent ?: ""
        )
    }

    fun convertNotificationToTempConfig(config: NotificationConfig, context: Context): TempNotificationConfig {
        return TempNotificationConfig(
            serviceId = config.serviceId,
            channelId = config.channelId,
            channelName = config.channelName,
            title = config.title ?: "",
            content = config.content ?: "",
            smallIcon = getDrawableNameByResourceId(context, config.smallIcon),
            largeIcon = getDrawableNameByResourceId(context, config.largeIcon),
            showLowBatteryNotification = config.showLowBatteryNotification,
            lowBatteryNotification = config.lowBatteryNotification,
            showAssetIdTakenNotification = config.showAssetIdTakenNotification,
            contentAssetDisable = config.contentAssetDisable ?: "",
            assetIdTakenContent = config.assetIdTakenContent ?: ""
        )
    }

    /**
     * Helper method to get drawable resource ID from string name
     */
    private fun getDrawableResourceId(context: Context, name: String): Int {
        return if (name.isNotEmpty()) {
            context.resources.getIdentifier(name, "drawable", context.packageName)
        } else {
            0 // Return 0 if name is empty or null
        }
    }

    private fun getDrawableNameByResourceId(context: Context, resourceId: Int): String {
        if (resourceId == 0) {
            return "";
        }
        return context.resources.getResourceEntryName(resourceId)
    }

    fun batteryConfigFromJson(jsonString: String): LowBatteryNotificationConfig {
        val gson = Gson()
        return gson.fromJson(jsonString, LowBatteryNotificationConfig::class.java)
    }

    fun batteryConfigToJson(config: LowBatteryNotificationConfig): String {
        val gson = Gson()
        return gson.toJson(config, LowBatteryNotificationConfig::class.java)
    }

    fun locationConfigFromJson(jsonString: String): LocationConfig {
        val jsonObject = JSONObject(jsonString)
        val json = mutableMapOf<String, Any>()

        val keys = jsonObject.keys()
        while (keys.hasNext()) {
            val key = keys.next()
            val value = jsonObject.get(key)
            json[key] = value
        }

        val desiredAccuracy: DesiredAccuracy = when (json["desiredAccuracy"]) {
            "high" -> {
                DesiredAccuracy.HIGH
            }

            "medium" -> {
                DesiredAccuracy.BALANCED
            }

            "low" -> {
                DesiredAccuracy.LOW
            }
            else -> {
                DesiredAccuracy.HIGH
            }
        }

        when (json["trackingMode"]) {
            "active" -> {
                return LocationConfig(TrackingMode.ACTIVE)
            }
            "balanced" -> {
                return LocationConfig(TrackingMode.BALANCED)
            }
            "passive" -> {
                return LocationConfig(TrackingMode.PASSIVE)
            }
            else -> {
                return LocationConfig(
                    interval = (json["interval"] as Int).toLong(),
                    smallestDisplacement = (json["smallestDisplacement"] as Double).toFloat(),
                    desiredAccuracy = desiredAccuracy,
                    maxWaitTime = (json["maxWaitTime"] as Int).toLong(),
                    fastestInterval = (json["fastestInterval"] as Int).toLong(),
                    enableStationaryCheck = json["enableStationaryCheck"] as Boolean
                )
            }
        }
    }

    fun locationConfigToJson(config: LocationConfig): String {
        val gson = Gson()
        val trackingMode: String = when (config.trackingMode) {
            TrackingMode.ACTIVE -> {
                "active"
            }

            TrackingMode.BALANCED -> {
                "balanced"
            }

            TrackingMode.PASSIVE -> {
                "passive"
            }

            else -> {
                "custom"
            }
        }

        val desiredAccuracy: String = when (config.desiredAccuracy) {
            DesiredAccuracy.HIGH -> {
                "high"
            }

            DesiredAccuracy.BALANCED -> {
                "medium"
            }

            DesiredAccuracy.LOW -> {
                "low"
            }

            else -> {
                "high"
            }
        }

        val map = mapOf(
            "trackingMode" to trackingMode,
            "interval" to config.interval,
            "smallestDisplacement" to config.smallestDisplacement,
            "maxWaitTime" to config.maxWaitTime,
            "fastestInterval" to config.fastestInterval,
            "enableStationaryCheck" to config.enableStationaryCheck,
            "desiredAccuracy" to desiredAccuracy
        )
        return gson.toJson(map, Map::class.java)
    }

    fun dataTrackingConfigFromJson(jsonString: String): DataTrackingConfig {
        val gson = Gson()
        return gson.fromJson(jsonString, DataTrackingConfig::class.java)
    }

    fun dataTrackingConfigToJson(config: DataTrackingConfig): String {
        val gson = Gson()
        return gson.toJson(config, DataTrackingConfig::class.java)
    }

    fun assetProfileFromJson(json: String): AssetProfile {
        val gson = Gson()
        return gson.fromJson(json, AssetProfile::class.java)
    }

    fun assetProfileToJson(profile: AssetProfile): String {
        val gson = Gson()
        return gson.toJson(profile, AssetProfile::class.java)
    }

    fun convertLocationToMap(location: Location?): String {
        val locationMap = mutableMapOf<String, Any>()
        location?.let {
            locationMap["latitude"] = it.latitude
            locationMap["longitude"] = it.longitude
            locationMap["accuracy"] = it.accuracy.toDouble()
            locationMap["altitude"] = it.altitude
            locationMap["speed"] = it.speed.toDouble()
            locationMap["speedAccuracy"] = 0.0 // Android doesn't provide speed accuracy
            locationMap["heading"] = it.bearing.toDouble()
            locationMap["provider"] = it.provider ?: "Unknown"
            locationMap["timestamp"] = it.time ?: 0
        }
        val jsonObject = (locationMap as Map<*, *>?)?.let { JSONObject(it) }
        return jsonObject.toString()
    }

    fun tripProfileFromJson(json: String): TripProfile {
        val gson = Gson()
        return gson.fromJson(json, TripProfile::class.java)
    }

    fun tripUpdateProfileFromJson(json: String): TripUpdateProfile {
        val gson = Gson()
        return gson.fromJson(json, TripUpdateProfile::class.java)
    }

    fun tripToJson(trip: Trip): String {
        val gson = Gson()
        return gson.toJson(trip)
    }

    fun summaryToJson(summary: TripSummary): String {
        val gson = Gson()
        return gson.toJson(summary, TripSummary::class.java)
    }
}

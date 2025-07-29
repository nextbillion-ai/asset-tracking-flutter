package ai.nextbillion.nb_asset_tracking_flutter

import ai.nextbillion.assettracking.assetTrackingAddCallback
import ai.nextbillion.assettracking.assetTrackingDeleteTrip
import ai.nextbillion.assettracking.assetTrackingEndTrip
import ai.nextbillion.assettracking.assetTrackingGetDataTrackingConfig
import ai.nextbillion.assettracking.assetTrackingGetDefaultConfig
import ai.nextbillion.assettracking.assetTrackingGetFakeGpsConfig
import ai.nextbillion.assettracking.assetTrackingGetLocationConfig
import ai.nextbillion.assettracking.assetTrackingGetNotificationConfig
import ai.nextbillion.assettracking.assetTrackingGetTripInfo
import ai.nextbillion.assettracking.assetTrackingIsRunning
import ai.nextbillion.assettracking.assetTrackingIsTripInProgress
import ai.nextbillion.assettracking.assetTrackingRemoveCallback
import ai.nextbillion.assettracking.assetTrackingSetDataTrackingConfig
import ai.nextbillion.assettracking.assetTrackingSetDefaultConfig
import ai.nextbillion.assettracking.assetTrackingSetLocationConfig
import ai.nextbillion.assettracking.assetTrackingSetNotificationConfig
import ai.nextbillion.assettracking.assetTrackingStart
import ai.nextbillion.assettracking.assetTrackingStartTrip
import ai.nextbillion.assettracking.assetTrackingStop
import ai.nextbillion.assettracking.assetTrackingTripId
import ai.nextbillion.assettracking.assetTrackingTripSummary
import ai.nextbillion.assettracking.assetTrackingUpdateFakeGpsConfig
import ai.nextbillion.assettracking.assetTrackingUpdateLocationConfig
import ai.nextbillion.assettracking.assetTrackingUpdateTrip
import ai.nextbillion.assettracking.bindAsset
import ai.nextbillion.assettracking.callback.AssetTrackingCallBack
import ai.nextbillion.assettracking.createNewAsset
import ai.nextbillion.assettracking.entity.FakeGpsConfig
import ai.nextbillion.assettracking.entity.TrackingDisableType
import ai.nextbillion.assettracking.entity.TripStatus
import ai.nextbillion.assettracking.forceBindAsset
import ai.nextbillion.assettracking.getAssetId
import ai.nextbillion.assettracking.getAssetInfo
import ai.nextbillion.assettracking.initialize
import ai.nextbillion.assettracking.setCrossPlatformInfo
import ai.nextbillion.assettracking.setKeyOfRequestHeader
import ai.nextbillion.assettracking.setUserId
import ai.nextbillion.assettracking.updateAssetInfo
import ai.nextbillion.network.AssetApiCallback
import ai.nextbillion.network.AssetException
import ai.nextbillion.network.create.AssetCreationResponse
import ai.nextbillion.network.get.Asset
import ai.nextbillion.network.get.GetAssetResponse
import ai.nextbillion.network.trip.entity.Trip
import ai.nextbillion.network.trip.entity.TripSummary
import android.app.Activity
import android.location.Location
import android.text.TextUtils
import com.google.gson.Gson
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MethodHandler(private val channel: MethodChannel) :
    AssetTrackingCallBack {

    fun addDataListener(activity: Activity) {
        activity.assetTrackingAddCallback(this)
    }

    fun removeDataListener(activity: Activity) {
        activity.assetTrackingRemoveCallback(this)
    }

    fun dispatchMethodHandler(
        activity: Activity?,
        call: MethodCall?,
        methodResult: MethodChannel.Result?
    ) {
        if (null == call || null == methodResult) {
            return
        }
        if (activity == null) {
            methodResult.success(
                AssetResult(
                    success = false,
                    data = "",
                    msg = "Activity have not attached"
                )
            )
            return
        }

        val method = call.method
        if (TextUtils.isEmpty(method)) {
            return
        }
        when (call.method) {
            "initialize" -> {
                val key = call.arguments as String
                // Initialize with the key if necessary
                activity.initialize(key)
                val crossPlatformName = String.format(
                    "Flutter-%s-%s",
                    BuildConfig.NBTRACKING_FLUTTER_VERSION,
                    BuildConfig.GIT_REVISION_SHORT
                )
                activity.setCrossPlatformInfo(crossPlatformName)
                methodResult.success(AssetResult(success = true, "", msg = "").toJson())
            }
            "setKeyOfHeaderField" -> {
                val key = call.arguments as String
                // Initialize with the key if necessary
                activity.setKeyOfRequestHeader(key)
                methodResult.success(AssetResult(success = true, "", msg = "").toJson())
            }
            "setupUserId" -> {
                val userId = call.arguments as String
                activity.setUserId(userId)
                methodResult.success(AssetResult(success = true, "", msg = "").toJson())
            }
            "getAssetId" -> {
                val assetId = activity.getAssetId()
                methodResult.success(AssetResult(success = true, assetId, msg = "").toJson())
            }

            "getAssetDetail" -> {
                activity.getAssetInfo(object : AssetApiCallback<GetAssetResponse> {

                    override fun onSuccess(result: GetAssetResponse) {
                        val asset: Asset = result.data.asset
                        val assetJsonString = Gson().toJson(asset)
                        methodResult.success(
                            AssetResult(
                                success = true,
                                assetJsonString,
                                msg = ""
                            ).toJson()
                        )
                    }

                    override fun onFailure(exception: AssetException) {
                        val exceptionMessage = exception.message ?: ""
                        methodResult.success(
                            AssetResult(
                                success = false,
                                exception.errorCode,
                                msg = exceptionMessage
                            ).toJson()
                        )
                    }
                })
            }

            "getDefaultConfig" -> {
                val config = activity.assetTrackingGetDefaultConfig()
                methodResult.success(AssetResult(success = true, config, msg = "").toJson())
            }
            "setDefaultConfig" -> {
                val string = call.arguments as String
                val config = ConfigConverter.defaultConfigFromJson(string)
                activity.assetTrackingSetDefaultConfig(config)
                methodResult.success(AssetResult(success = true, config, msg = "").toJson())
            }

            "setAndroidNotificationConfig" -> {
                val string = call.arguments as String
                val tempConfig = ConfigConverter.notificationConfigFromJson(string)
                val config = ConfigConverter.convertTempToNotificationConfig(tempConfig, activity)
                activity.assetTrackingSetNotificationConfig(config)
                methodResult.success(AssetResult(success = true, "", msg = "").toJson())
            }
            "getAndroidNotificationConfig" -> {
                val config = activity.assetTrackingGetNotificationConfig()
                val tempConfig = ConfigConverter.convertNotificationToTempConfig(config,activity)
                methodResult.success(AssetResult(success = true, tempConfig, msg = "").toJson())
            }

            "updateLocationConfig" -> {
                val string = call.arguments as String
                val config = ConfigConverter.locationConfigFromJson(string)
                activity.assetTrackingUpdateLocationConfig(config)
                methodResult.success(AssetResult(success = true, "", msg = "").toJson())
            }

            "setLocationConfig" -> {
                val map = call.arguments as String
                val config = ConfigConverter.locationConfigFromJson(map)
                activity.assetTrackingSetLocationConfig(config)
                methodResult.success(AssetResult(success = true, "", msg = "").toJson())
            }

            "getLocationConfig" -> {
                val config = activity.assetTrackingGetLocationConfig()
                val json = ConfigConverter.locationConfigToJson(config)
                methodResult.success(AssetResult(success = true, json, msg = "").toJson())
            }

            "setDataTrackingConfig" -> {
                val string = call.arguments as String
                val config = ConfigConverter.dataTrackingConfigFromJson(string)
                activity.assetTrackingSetDataTrackingConfig(config)
                methodResult.success(AssetResult(success = true, "", msg = "").toJson())
            }

            "getDataTrackingConfig" -> {
                val config = activity.assetTrackingGetDataTrackingConfig()
                val map = ConfigConverter.dataTrackingConfigToJson(config)
                methodResult.success(AssetResult(success = true, map, msg = "").toJson())
            }

            "isTracking" -> {
                methodResult.success(
                    AssetResult(
                        success = true,
                        activity.assetTrackingIsRunning,
                        msg = ""
                    ).toJson()
                )
            }

            "createAsset" -> {
                val profileString = call.arguments as String
                val profile = ConfigConverter.assetProfileFromJson(profileString)
                activity.createNewAsset(
                    profile,
                    object : AssetApiCallback<AssetCreationResponse> {

                        override fun onFailure(exception: AssetException) {
                            val exceptionMessage = exception.message ?: ""
                            val errorCode = exception.errorCode
                            methodResult.success(
                                AssetResult(
                                    success = false,
                                    errorCode.toString(),
                                    msg = exceptionMessage
                                ).toJson()
                            )
                        }

                        override fun onSuccess(result: AssetCreationResponse) {
                            methodResult.success(
                                AssetResult(
                                    success = true,
                                    result.data.id,
                                    msg = result.toString()
                                ).toJson()
                            )
                        }
                    }
                )
            }

            "bindAsset" -> run {
                val assetId = call.arguments as String
                activity.bindAsset(
                    assetId,
                    object : AssetApiCallback<Unit> {

                        override fun onFailure(exception: AssetException) {
                            val exceptionMessage = exception.message ?: ""
                            methodResult.success(
                                AssetResult(
                                    success = false,
                                    exception.errorCode.toString(),
                                    msg = exceptionMessage
                                ).toJson()
                            )
                        }

                        override fun onSuccess(result: Unit) {
                            methodResult.success(
                                AssetResult(
                                    success = true,
                                    assetId,
                                    msg = result.toString()
                                ).toJson()
                            )
                        }
                    }
                )
            }

            "updateAsset" -> run {
                val profileString = call.arguments as String
                val profile = ConfigConverter.assetProfileFromJson(profileString)
                activity.updateAssetInfo(
                    assetProfile = profile,
                    callback = object : AssetApiCallback<Unit> {

                        override fun onFailure(exception: AssetException) {
                            val exceptionMessage = exception.message ?: ""
                            methodResult.success(
                                AssetResult(
                                    success = false,
                                    profile.name,
                                    msg = exceptionMessage
                                ).toJson()
                            )
                        }

                        override fun onSuccess(result: Unit) {
                            methodResult.success(
                                AssetResult(
                                    success = true,
                                    result.toString(),
                                    msg = ""
                                ).toJson()
                            )
                        }
                    }
                )
            }

            "forceBindAsset" -> {
                val assetId = call.arguments as String
                activity.forceBindAsset(
                    assetId,
                    object : AssetApiCallback<Unit> {

                        override fun onFailure(exception: AssetException) {
                            val exceptionMessage = exception.message ?: ""
                            methodResult.success(
                                AssetResult(
                                    success = false,
                                    exception.errorCode.toString(),
                                    msg = exceptionMessage
                                ).toJson()
                            )
                        }

                        override fun onSuccess(result: Unit) {
                            methodResult.success(
                                AssetResult(
                                    success = true,
                                    result.toString(),
                                    msg = result.toString()
                                ).toJson()
                            )
                        }
                    }
                )
            }

            "startTracking" -> {
                activity.assetTrackingStart()
                methodResult.success(
                    AssetResult(
                        success = true,
                        "",
                        msg = ""
                    ).toJson()
                )
            }

            "stopTracking" -> {
                activity.assetTrackingStop()
                methodResult.success(
                    AssetResult(
                        success = true,
                        "",
                        msg = ""
                    ).toJson()
                )
            }

            "setFakeGpsConfig" -> {
                val allow = call.arguments as Boolean
                activity.assetTrackingUpdateFakeGpsConfig(FakeGpsConfig(allow))
                methodResult.success(
                    AssetResult(
                        success = true,
                        "",
                        msg = ""
                    ).toJson()
                )
            }

            "getFakeGpsConfig" -> {
                val allow = activity.assetTrackingGetFakeGpsConfig()
                methodResult.success(
                    AssetResult(
                        success = true,
                        allow.allowUseVirtualLocation,
                        msg = ""
                    ).toJson()
                )
            }

            "startTrip" -> {
                val profileString = call.arguments as String
                val profile = ConfigConverter.tripProfileFromJson(profileString)
                activity.assetTrackingStartTrip(
                    profile,
                    true,
                    object : AssetApiCallback<String> {

                        override fun onFailure(exception: AssetException) {
                            val exceptionMessage = exception.message ?: ""
                            methodResult.success(
                                AssetResult(
                                    success = false,
                                    profile.name,
                                    msg = exceptionMessage
                                ).toJson()
                            )
                        }

                        override fun onSuccess(result: String) {
                            methodResult.success(
                                AssetResult(
                                    success = true,
                                    result,
                                    msg = result
                                ).toJson()
                            )
                        }
                    }
                )
            }

            "endTrip" -> {
                activity.assetTrackingEndTrip(object : AssetApiCallback<String> {

                    override fun onFailure(exception: AssetException) {
                        val exceptionMessage = exception.message ?: ""
                        methodResult.success(
                            AssetResult(
                                success = false,
                                "",
                                msg = exceptionMessage
                            ).toJson()
                        )
                    }

                    override fun onSuccess(result: String) {
                        methodResult.success(
                            AssetResult(
                                success = true,
                                result,
                                msg = null
                            ).toJson()
                        )
                    }
                })
            }

            "getTrip" -> {
                val tripId = call.arguments as String
                activity.assetTrackingGetTripInfo(
                    tripId,
                    object : AssetApiCallback<Trip> {

                        override fun onFailure(exception: AssetException) {
                            val exceptionMessage = exception.message ?: ""
                            methodResult.success(
                                AssetResult(
                                    success = false,
                                    tripId,
                                    msg = exceptionMessage
                                ).toJson()
                            )
                        }

                        override fun onSuccess(result: Trip) {
                            methodResult.success(
                                AssetResult(
                                    success = true,
                                    result,
                                    msg = ""
                                ).toJson()
                            )
                        }
                    }
                )
            }

            "updateTrip" -> {
                val profileString = call.arguments as String
                val profile = ConfigConverter.tripUpdateProfileFromJson(profileString)
                activity.assetTrackingUpdateTrip(
                    profile,
                    object : AssetApiCallback<String> {

                        override fun onFailure(exception: AssetException) {
                            val exceptionMessage = exception.message ?: ""
                            methodResult.success(
                                AssetResult(
                                    success = false,
                                    profile.name,
                                    msg = exceptionMessage
                                ).toJson()
                            )
                        }

                        override fun onSuccess(result: String) {
                            methodResult.success(
                                AssetResult(
                                    success = true,
                                    result,
                                    msg = ""
                                ).toJson()
                            )
                        }
                    }
                )
            }
            "getSummary" -> {
                val tripId = call.arguments as String
                activity.assetTrackingTripSummary(
                    tripId,
                    object : AssetApiCallback<TripSummary> {

                        override fun onFailure(exception: AssetException) {
                            val exceptionMessage = exception.message ?: ""
                            methodResult.success(
                                AssetResult(
                                    success = false,
                                    tripId,
                                    msg = exceptionMessage
                                ).toJson()
                            )
                        }

                        override fun onSuccess(result: TripSummary) {
                            methodResult.success(
                                AssetResult(
                                    success = true,
                                    result,
                                    msg = ""
                                ).toJson()
                            )
                        }
                    }
                )
            }
            "deleteTrip" -> {
                val tripId = call.arguments as String
                activity.assetTrackingDeleteTrip(
                    tripId,
                    object : AssetApiCallback<String> {

                        override fun onFailure(exception: AssetException) {
                            val exceptionMessage = exception.message ?: ""
                            methodResult.success(
                                AssetResult(
                                    success = false,
                                    tripId,
                                    msg = exceptionMessage
                                ).toJson()
                            )
                        }

                        override fun onSuccess(result: String) {
                            methodResult.success(
                                AssetResult(
                                    success = true,
                                    result,
                                    msg = ""
                                ).toJson()
                            )
                        }
                    }
                )
            }
            "getActiveTripId" -> {
                activity.assetTrackingTripId()?.let {
                    methodResult.success(
                        AssetResult(
                            success = true,
                            it,
                            msg = ""
                        ).toJson()
                    )
                } ?: methodResult.success(
                    AssetResult(
                        success = false,
                        "",
                        msg = "No active trip"
                    ).toJson()
                )
            }
            "isTripInProgress" -> {
                activity.assetTrackingIsTripInProgress.let {
                    methodResult.success(
                        AssetResult(
                            success = true,
                            it,
                            msg = ""
                        ).toJson()
                    )
                }
            }
            else -> methodResult.notImplemented()
        }
    }

    override fun onLocationFailure(exception: Exception) {
        channel.invokeMethod(
            "check demo onLocationFailure",
            AssetResult(
                success = true,
                exception.message,
                msg = exception.message
            ).toJson()
        )
    }

    override fun onLocationSuccess(location: Location) {
        channel.invokeMethod(
            "onLocationSuccess",
            AssetResult(
                success = true,
                ConfigConverter.convertLocationToMap(location),
                msg = ""
            ).toJson()
        )
    }

    override fun onTrackingStart(assetId: String) {
        channel.invokeMethod(
            "onTrackingStart",
            AssetResult(
                success = true,
                assetId,
                msg = ""
            ).toJson()
        )
    }

    override fun onTrackingStop(assetId: String, trackingDisableType: TrackingDisableType) {
        channel.invokeMethod(
            "onTrackingStop",
            AssetResult(
                success = true,
                assetId,
                msg = trackingDisableType.name
            ).toJson()
        )
    }

    override fun onTripStatusChanged(tripId: String, status: TripStatus) {
        channel.invokeMethod(
            "onTripStatusChanged",
            AssetResult(
                success = true,
                mapOf("tripId" to tripId, "status" to status.name).toString(),
                msg = null
            ).toJson()
        )
    }

    fun deInit() {
    }
}

const fz = require('zigbee-herdsman-converters/converters/fromZigbee');
const tz = require('zigbee-herdsman-converters/converters/toZigbee');
const exposes = require('zigbee-herdsman-converters/lib/exposes');
const reporting = require('zigbee-herdsman-converters/lib/reporting');
const extend = require('zigbee-herdsman-converters/lib/extend');
const e = exposes.presets;
const ea = exposes.access;

const definition = {
    zigbeeModel: ['3156105'],
    model: '3156105',
    vendor: 'Centralite',
    description: 'HA Thermostat,',
    fromZigbee: [fz.battery, fz.legacy.thermostat_att_report, fz.fan, fz.ignore_time_read],
    toZigbee: [tz.factory_reset, tz.thermostat_local_temperature, tz.thermostat_local_temperature_calibration,
        tz.thermostat_occupied_heating_setpoint, tz.thermostat_occupied_cooling_setpoint,
        tz.thermostat_setpoint_raise_lower, tz.thermostat_remote_sensing,
        tz.thermostat_control_sequence_of_operation, tz.thermostat_system_mode,
        tz.thermostat_relay_status_log, tz.fan_mode, tz.thermostat_running_state],
    exposes: [e.battery(), exposes.climate().withSetpoint('occupied_heating_setpoint', 10, 30, 1).withLocalTemperature()
        .withSystemMode(['off', 'heat', 'cool', 'emergency_heating'])
        .withRunningState(['idle', 'heat', 'cool', 'fan_only']).withFanMode(['auto', 'on'])
        .withSetpoint('occupied_cooling_setpoint', 10, 30, 1).withLocalTemperatureCalibration()],
    meta: {battery: {voltageToPercentage: '3V_1500_2800'}},
    configure: async (device, coordinatorEndpoint, logger) => {
        const endpoint = device.getEndpoint(1);
        await reporting.bind(endpoint, coordinatorEndpoint, ['genPowerCfg', 'hvacThermostat', 'hvacFanCtrl']);
        await reporting.batteryVoltage(endpoint);
        await reporting.thermostatRunningState(endpoint);
        await reporting.thermostatTemperature(endpoint);
        await reporting.fanMode(endpoint);
    },
};

module.exports = definition;

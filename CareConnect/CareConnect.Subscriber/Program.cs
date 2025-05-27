// See https://aka.ms/new-console-template for more information

//todo

using EasyNetQ;
using CareConnect.Models.Messages;

var bus = RabbitHutch.CreateBus("host=localhost;username=admin;password=admin");

await bus.PubSub.SubscribeAsync<AppointmentScheduled>("appointment", msg =>
{
    Console.WriteLine($"Appointment scheduled on date: {msg.Appointment.Date}");
});

Console.WriteLine("Listening for messages, press <return> key to close!");
Console.ReadLine();
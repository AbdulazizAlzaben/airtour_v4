import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/cloud/cloud_booking.dart';
import '../../services/cloud/cloud_flight.dart';
import '../../services/cloud/cloud_ticket.dart';
import '../../services/cloud/firestore_flight.dart';
import '../Global/global_var.dart';

class BoardingPass extends StatefulWidget {
  final CloudTicket ticket;
  final CloudBooking booking;
  final CloudFlight flight;
  const BoardingPass(
      {super.key,
      required this.ticket,
      required this.flight,
      required this.booking});

  @override
  State<BoardingPass> createState() => _BoardingPassState();
}

class _BoardingPassState extends State<BoardingPass> {
  late final FlightFirestore _flightsService;

  @override
  void initState() {
    super.initState();
    _flightsService = FlightFirestore();
  }

  String date1(Timestamp date) {
    DateTime departureDate = date.toDate();
    DateFormat formatter = DateFormat('MM dd yyyy');
    String formattedDate = formatter.format(departureDate);
    List<String> parts = formattedDate.split(' ');
    int month = int.parse(parts[0]);
    String monthName = monthNames[month];
    String day = parts[1];
    String year = parts[2];
    return '$monthName $day $year';
  }

  String date2(Timestamp date) {
    DateTime departureDate = date.toDate();
    DateFormat formatter = DateFormat('MM dd yyyy');
    String formattedDate = formatter.format(departureDate);
    List<String> parts = formattedDate.split(' ');
    int month = int.parse(parts[0]);
    int monthName = month;
    String day = parts[1];
    String year = parts[2];
    return '$day/$monthName/$year';
  }

  String boardingTime(Timestamp departureTime) {
    DateTime departureDateTime = departureTime.toDate();
    DateTime boardingDateTime =
        departureDateTime.subtract(Duration(minutes: 30));

    String formattedBoardingTime =
        boardingDateTime.hour.toString().padLeft(2, '0') +
            ':' +
            boardingDateTime.minute.toString().padLeft(2, '0') +
            ' ' +
            (boardingDateTime.hour >= 12 ? 'PM' : 'AM');

    return formattedBoardingTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Boarding Pass"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       "Ticket:",
                          //       style: TextStyle(
                          //         fontSize: 18.0,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.black87,
                          //       ),
                          //     ),
                          //     Text("Booking Reference:",
                          //         style: TextStyle(
                          //           fontSize: 18.0,
                          //           fontWeight: FontWeight.bold,
                          //           color: Colors.black87,
                          //         ))
                          //   ],
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(widget.ticket.documentId),
                          //     Text(widget.booking.documentId)
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //   height: 1.0,
                          //   color: Colors.black,
                          //   width: double.infinity,
                          //   //child: SizedBox.expand(),
                          // ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name:",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text("Birth Date:",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${widget.ticket.firstName} ${widget.ticket.middleName} ${widget.ticket.lastName}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(date2(widget.ticket.birthDate))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Boarding time:",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "Departure:",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                boardingTime(widget.flight.depTime),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Row(
                                children: [
                                  Text("${date1(widget.flight.depDate)}  "),
                                  Text(
                                    _flightsService
                                        .formatTime(widget.flight.depTime),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.flight.fromCity,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 30,
                                child: Image.asset('images/flight-Icon.png'),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                widget.flight.toCity,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 1.0,
                            color: Colors.black,
                            width: double.infinity,
                            //child: SizedBox.expand(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Airport:",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  )),
                              Text("Airport:",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.flight.fromAirport),
                              Text(widget.flight.toAirport)
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Flight:",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  )),
                              Text("class:",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.flight.documentId),
                              Text(widget.ticket.ticketClass)
                            ],
                          ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // const Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text("Meal Type:",
                          //         style: TextStyle(
                          //           fontSize: 18.0,
                          //           fontWeight: FontWeight.bold,
                          //           color: Colors.black87,
                          //         )),
                          //     Row(
                          //       children: [
                          //         Text("Baggage quantity:",
                          //             style: TextStyle(
                          //               fontSize: 18.0,
                          //               fontWeight: FontWeight.bold,
                          //               color: Colors.black87,
                          //             )),
                          //         //Text("${ticket.bagQuantity}")
                          //       ],
                          //     )
                          //   ],
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(widget.ticket.mealType),
                          //     Text("${widget.ticket.bagQuantity}")
                          //   ],
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            height: 100,
                            child: Image.asset('images/BarCode.jpeg'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

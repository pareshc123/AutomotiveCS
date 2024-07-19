import can
import time
import threading


def send_can_message(bus):

    # Wait a bit before sending the message to ensure the reception function is ready
    time.sleep(1)

    # Example of sending a message
    print("Attempting to send message...")
    msg = can.Message(arbitration_id=0x123, data=[0x11, 0x22, 0x33], is_extended_id=False)
    try:
        bus.send(msg)
        print(f"Message sent: {msg}")
    except can.CanError as e:
        print(f"Failed to send message: {e}")


def receive_can_message(bus):

    # Example of receiving a message
    received_msg = bus.recv(timeout=10.0)          # Wait for up to 10 seconds for a message

    if received_msg:
        print(f"Message received: {received_msg}, Data: {received_msg.data}")
        command = received_msg.data[0]             # Assuming the first byte of data represents a command

        if command == 0x11:
            print("Command: Increase speed")
        elif command == 0x22:
            print("Current speed reading")
        elif command == 0x33:
            print("Status of system component")

    else:
        print("No message received within the timeout period.")


def main():

    bus = None
    try:
        # Set up the virtual CAN bus for testing
        bus = can.Bus(interface='virtual', channel='vcan0', bitrate=500000)
        print(f"{bus = }")

        # Start a thread to send a CAN message
        sender_thread = threading.Thread(target=send_can_message, args=(bus,))
        sender_thread.start()

        # Start a thread to receive CAN message
        receiver_thread = threading.Thread(target=receive_can_message, args=(bus,))
        receiver_thread.start()

        # Wait for threads to complete
        sender_thread.join()
        receiver_thread.join()

    except Exception as e:
        print(f"An error occurred: {e}")

    finally:
        # Ensure the bus is properly shut down
        if bus is not None:
            bus.shutdown()


if __name__ == "__main__":
    main()

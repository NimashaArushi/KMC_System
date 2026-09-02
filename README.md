# KMC Event Management Platform (CSE5013 - Service Oriented Computing)

A full-stack Service-Oriented architecture designed for the KMC Event Management Platform, featuring a separate SQL Server database, an ASP.NET Core Web API backend (`KMC_API`), and a client interface (`KMC_Client`).

---

## **Project Structure**

* **`KMC_API/`**: ASP.NET Core Web API handling full CRUD operations for Events, Organizers, Event Types, and Participants.
* **`KMC_Client/`**: Client application interface interacting with the underlying API services.
* **`KMC_System.sln`**: Solution file binding the complete system architecture together.

---

## **Database Architecture (`KMC_EventsDB`)**

The platform runs on a standalone Microsoft SQL Server database configured with 3NF normalization principles and cascading integrity constraints:

* **`Organizer`**: Tracks event creators/owners for authorization tracking (`OrganizerID`, `Name`, `Email`, `Phone`).
* **`EventType`**: Lookup table containing standardized categories: *Cultural, Sports, Music, Exhibition, Community, Workshop*.
* **`Event`**: Core operational table maintaining full CRUD capabilities with foreign keys to `Organizer` and `EventType`.
* **`Participant`**: Secondary registration table linking participants to specific events with automated `ON DELETE CASCADE` rules.

---

## **Getting Started**

### **1. Database Setup**
Execute the database schema creation and sample data script in Microsoft SQL Server Management Studio (SSMS):
```sql
-- Ensure your SQL Server instance is running and execute:
CREATE DATABASE KMC_EventsDB;

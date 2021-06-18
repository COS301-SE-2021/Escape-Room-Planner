import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { appRoutingModule } from './app.routing';
import { AppComponent } from './app.component';
import { LoginComponent } from './pages/login/login.component';
import { SignupComponent } from './pages/signup/signup.component';
import { RoomCreatorComponent } from './pages/room-creator/room-creator.component';


@NgModule({
  imports: [
    BrowserModule,
    appRoutingModule,
  ],
  declarations: [
    AppComponent,
    LoginComponent,
    SignupComponent,
    RoomCreatorComponent
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }

import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import {RouterModule, Routes} from "@angular/router";

import { AppComponent } from './app.component';
import { LoginComponent } from './pages/login/login.component';
import { RoomCreatorComponent } from './pages/room-creator/room-creator.component';
import { SignupComponent } from './pages/signup/signup.component';
import {HttpClientModule} from "@angular/common/http";
import {FormsModule} from "@angular/forms";
import { InventoryComponent } from './pages/inventory/inventory.component';

const routes: Routes = [
  // { path: '', component: AppComponent },
  { path: 'signup', component: SignupComponent },
  { path: 'login', component: LoginComponent },
  { path: 'escape-room', component: RoomCreatorComponent},
  // otherwise redirect to login
  { path: '**', redirectTo: '' }
];

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    RoomCreatorComponent,
    SignupComponent,
    InventoryComponent
  ],
    imports: [
        BrowserModule,
        RouterModule.forRoot(routes),
        HttpClientModule,
        FormsModule
    ],
  providers: [],
  bootstrap: [AppComponent]
})
//export const appRoutingModule = RouterModule.forRoot(routes);

export class AppModule { }

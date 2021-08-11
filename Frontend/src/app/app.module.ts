import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import {RouterModule, Routes} from "@angular/router";

import { AppComponent } from './app.component';
import { LoginComponent } from './pages/login/login.component';
import { RoomCreatorComponent } from './pages/room-creator/room-creator.component';
import { SignupComponent } from './pages/signup/signup.component';
import { DraggableDirective } from './directives/draggable.directive';
import { DroppableDirective } from './directives/droppable.directive';
import {HttpClientModule} from "@angular/common/http";
import {FormsModule} from "@angular/forms";

const routes: Routes = [
  { path: 'room', component: RoomCreatorComponent },
  { path: 'signup', component: SignupComponent },
  { path: '/', component: LoginComponent },
  // otherwise redirect to login
  { path: '**', redirectTo: '' }
];

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    RoomCreatorComponent,
    SignupComponent,
    DraggableDirective,
    DroppableDirective
  ],
    imports: [
        BrowserModule,
        RouterModule.forRoot(routes),
        HttpClientModule,
        FormsModule,
    ],
  providers: [],
  bootstrap: [AppComponent]
})
//export const appRoutingModule = RouterModule.forRoot(routes);

export class AppModule { }

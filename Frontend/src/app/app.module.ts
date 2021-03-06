import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import {RouterModule, Routes} from "@angular/router";
import {NgbModule} from "@ng-bootstrap/ng-bootstrap";

import { AppComponent } from './app.component';
import { LoginComponent } from './pages/login/login.component';
import { RoomCreatorComponent } from './pages/room-creator/room-creator.component';
import { SignupComponent } from './pages/signup/signup.component';
import { HttpClientModule} from "@angular/common/http";
import { FormsModule} from "@angular/forms";
import { VerifyComponent } from './pages/verify/verify.component';
import { ResetPasswordComponent } from './pages/reset-password/reset-password.component';
import { ResetPasswordNotComponent } from './pages/reset-password-not/reset-password-not.component';
import { InventoryComponent } from './pages/inventory/inventory.component';
import { SolvabilityComponent } from './pages/solvability/solvability.component';
import { VerifySuccessComponent } from './pages/verify-success/verify-success.component';
import { VerifyFailedComponent } from './pages/verify-failed/verify-failed.component';
import { DependencyDiagramComponent } from './pages/dependency-diagram/dependency-diagram.component';
import { SimulationComponent } from './pages/simulation/simulation.component';
import { PublicEscapeRoomsComponent } from './pages/public-escape-rooms/public-escape-rooms.component';

const routes: Routes = [
  // { path: '', component: AppComponent },
  { path: 'signup', component: SignupComponent },
  { path: 'login', component: LoginComponent },
  { path: 'verify', component: VerifyComponent },
  { path: 'reset', component: ResetPasswordComponent },
  { path: 'reset-not', component: ResetPasswordNotComponent },
  { path: 'escape-room', component: RoomCreatorComponent},
  { path: 'diagram', component: DependencyDiagramComponent },
  { path: 'verify-success', component: VerifySuccessComponent},
  { path: 'verify-failure', component: VerifyFailedComponent},
  { path: 'simulation', component: SimulationComponent},
  { path: 'public-escape-rooms', component: PublicEscapeRoomsComponent},
  // otherwise redirect to login
  { path: '**', redirectTo: '' }
];

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    RoomCreatorComponent,
    SignupComponent,
    VerifyComponent,
    ResetPasswordComponent,
    ResetPasswordNotComponent,
    InventoryComponent,
    SolvabilityComponent,
    VerifySuccessComponent,
    VerifyFailedComponent,
    DependencyDiagramComponent,
    SimulationComponent,
    PublicEscapeRoomsComponent
  ],
    imports: [
        BrowserModule,
        RouterModule.forRoot(routes),
        HttpClientModule,
        FormsModule,
        NgbModule
    ],
  providers: [],
  bootstrap: [AppComponent]
})
//export const appRoutingModule = RouterModule.forRoot(routes);

export class AppModule { }

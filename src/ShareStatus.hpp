/* Copyright (c) 2012 Research In Motion Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef SHARESTATUS_HPP
#define SHARESTATUS_HPP

#include <QtCore/QObject>
#include <bb/platform/bbm/UserProfile>

namespace bb
{
namespace platform
{
namespace bbm
{
class Context;
class MessageService;
}
}
}

/**
 * @brief A class that encapsulates the sending of the 'Invite to Download' message.
 */
//! [0]
class ShareStatus : public QObject
{
    Q_OBJECT

public:
    /**
     * Creates a new 'invite to download' object.
     *
     * @param parent The parent object.
     */
    ShareStatus(bb::platform::bbm::Context &context, QObject *parent = 0);

    // This method is invoked to open the invitation dialog
    Q_INVOKABLE void shareStatus();

public Q_SLOTS:
    // This methods creates the main UI and initializes the message service
    void show();

private:
    // The service object to send BBM messages
    bb::platform::bbm::MessageService* m_messageService;
    bb::platform::bbm::Context* m_context;
    bb::platform::bbm::UserProfile* m_userProfile;

};
//! [0]

#endif

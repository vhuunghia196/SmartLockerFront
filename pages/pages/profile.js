// import node module libraries
import { Col, Row, Container } from 'react-bootstrap';

// import widget as custom components
import { PageHeading } from 'widgets'

// import sub components
import {
  AboutMe,
  ActivityFeed,
  MyTeam,
  ProfileHeader,
  ProjectsContributions,
  RecentFromBlog
} from 'sub-components'
import { getUserCookie } from   'utils/auth'

const Profile = () => {
  const user = getUserCookie();
  return (
    <Container fluid className="p-6">
      {/* Page Heading */}
      <PageHeading heading="Tổng quan"/>

      {/* Profile Header  */}
      <ProfileHeader user={user} />

      {/* content */}
      <div className="py-6">
        <AboutMe />

      </div>

    </Container>
  )
}

export default Profile